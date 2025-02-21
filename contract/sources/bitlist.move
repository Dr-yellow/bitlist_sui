/// Module: bitlist
module bitlist::bitlist;
use std::string::{Self, String};
use sui::table::{Self, Table};
use sui::sui::SUI;
use sui::coin::{Self, Coin};
use sui::balance::{Self, Balance};
use sui::event;
use sui::clock::{Self, Clock};
use sui::vec_set::{Self, VecSet};

const EPublicContentEmpty: u64 = 1;
const EBitListTitleTooLong: u64 = 2;
const EPublicContentTooLong: u64 = 3;
const EPrivateContentTooLong: u64 = 4;
const EInsufficientPayment: u64 = 5;
const EInvalidWithdrawalAmount: u64 = 6;
const EInvalidItemId: u64 = 7;
const EAlreadyPurchased: u64 = 8;

const MAX_BITLIST_TITLE_LENGTH: u64 = 1024;
const MAX_BITLIST_PUBLIC_CONTENT_LENGTH: u64 = 4096;
const MAX_BITLIST_PRIVATE_CONTENT_LENGTH: u64 = 4096;

public struct EventAddItem has copy, drop {
    item_id: u64,
    owner: address,
    title: String,
    base_amount: u64,
    cost_amount: u64,
    public_content: String,
    private_content: String,
    created_at: u64,
}

public struct EventWithdrawal has copy, drop {
    amount: u64,
    recipient: address,
}

public struct EventItemPurchased has copy, drop {
    item_id: u64,
    buyer: address,
}

public struct BitList has key {
    id: UID,
    balance: Balance<SUI>,
    item_counter: u64,
    items: Table<u64, BitListItem>,
    buyers: Table<u64, VecSet<address>>,
}

public struct AdminCap has key {
    id: UID,
}

public struct BitListItem has key, store {
    id: UID,
    owner: address,
    title: String,
    base_amount: u64,
    cost_amount: u64,
    public_content: String,
    private_content: String, // 使用平台对称秘钥加密
    created_at: u64,
}

fun init(ctx: &mut TxContext) {

    let sender = tx_context::sender(ctx);

    transfer::transfer(AdminCap {
        id: object::new(ctx)
    }, sender);

    let bitlist = BitList {
        id: object::new(ctx),
        balance: balance::zero(),
        item_counter: 0,
        items: table::new(ctx),
        buyers: table::new(ctx),
    };

    transfer::share_object(bitlist);
}

public entry fun add_item(
    bitlist: &mut BitList,
    title: String,
    base_amount: u64,
    cost_amount: u64,
    public_content: vector<u8>,
    private_content: vector<u8>,
    payment_coin: &mut Coin<SUI>,
    clock: &Clock,
    ctx: &mut TxContext
) {
    let public_content = string::utf8(public_content);
    let private_content = string::utf8(private_content);
    // 只校验公共数据，私有数据可以为空
    assert!(public_content.length() > 0, EPublicContentEmpty);
    assert!(title.length() <= MAX_BITLIST_TITLE_LENGTH, EBitListTitleTooLong);
    assert!(public_content.length() <= MAX_BITLIST_PUBLIC_CONTENT_LENGTH, EPublicContentTooLong);
    assert!(private_content.length() <= MAX_BITLIST_PRIVATE_CONTENT_LENGTH, EPrivateContentTooLong);

    let value = payment_coin.value();
    assert!(value >= base_amount, EInsufficientPayment);
    let paid = payment_coin.split(base_amount, ctx);
    coin::put(&mut bitlist.balance, paid);

    let sender = ctx.sender();
    let item_id = bitlist.item_counter;
    let item = BitListItem {
        id: object::new(ctx),
        owner: sender,
        title,
        base_amount,
        cost_amount,
        public_content,
        private_content,
        created_at: clock::timestamp_ms(clock),
    };

    bitlist.items.add(item_id, item);

    bitlist.item_counter = item_id + 1;

    event::emit(EventAddItem {
        item_id,
        owner: sender,
        title,
        base_amount,
        cost_amount,
        public_content,
        private_content,
        created_at: clock::timestamp_ms(clock),
    });
}

public entry fun withdraw_from_bitlist(
    bitlist: &mut BitList,
    _: &AdminCap,
    amount: u64,
    ctx: &mut TxContext
) {
    assert!(amount > 0 && amount <= bitlist.balance.value(), EInvalidWithdrawalAmount);
    let take_coin = coin::take(&mut bitlist.balance, amount, ctx);
    let sender = ctx.sender();
    transfer::public_transfer(take_coin, sender);

    event::emit(EventWithdrawal{
        amount: amount,
        recipient: sender
    });
}

public entry fun purchase_item(
    bitlist: &mut BitList,
    item_id: u64,
    payment_coin: &mut coin::Coin<SUI>,
    ctx: &mut TxContext
) {
    assert!(item_id <= bitlist.items.length(), EInvalidItemId);
    let item = &mut bitlist.items[item_id];

    let value = payment_coin.value();
    assert!(value >= item.cost_amount, EInsufficientPayment);

    let paid = payment_coin.split(item.cost_amount, ctx);

    let buyer = ctx.sender();
    transfer::public_transfer(paid, buyer);

    if (!bitlist.buyers.contains(item_id)) {
        bitlist.buyers.add(item_id, vec_set::empty());
    };

    let buyers_set = &mut bitlist.buyers[item_id];
    assert!(!buyers_set.contains(&buyer), EAlreadyPurchased);
    buyers_set.insert(buyer);

    event::emit(EventItemPurchased {
        item_id: item_id,
        buyer: buyer,
    });
}

public entry fun check_user_purchased(
    bitlist: &BitList,
    item_id: u64,
    user: address,
) : bool {
    let buyers_set = bitlist.buyers.borrow(item_id);
    buyers_set.contains(&user)
}