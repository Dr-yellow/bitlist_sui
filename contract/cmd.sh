## 环境变量

```
PACKAGE_ID=0x8899a416e672c16fdc9d10190a6a0f6269ceb0c26a9bf9f12d5d8bedd03634d3
BITLIST_SHARE_OBJECT_ID=0x4a238aac9c389990c8dd69d170ae8fab47f95ab4f663b5713250274d70d8a647
```

## 合约调用

### 添加1
```
export TITLE="test title"
export BASE_AMOUNT=100000000
export COST_AMOUNT=100000000
export PUBLIC_CONTENT="test public content"
export PRIVATE_CONTENT="test private content"
export PAYMENT_COIN="0x6714f16fd59a9efc61aad6bdf36907809b5145c2ef63d496bfd07404d37232eb"
export CLOCK="0x6"

sui client call --package $PACKAGE_ID --module bitlist --function add_item --gas-budget 100000000 --args \
    $BITLIST_SHARE_OBJECT_ID \
    $TITLE \
    $BASE_AMOUNT \
    $COST_AMOUNT \
    $PUBLIC_CONTENT \
    $PRIVATE_CONTENT \
    $PAYMENT_COIN \
    $CLOCK

https://testnet.suivision.xyz/txblock/5KXDGsXZ3kPTjoWhrT3AHHFDw9a3KNdWA9KuPmnXDBBo
```

### 添加2
```
export TITLE="test title2"
export BASE_AMOUNT=100000000
export COST_AMOUNT=100000000
export PUBLIC_CONTENT="test public content2"
export PRIVATE_CONTENT="test private content2"
export PAYMENT_COIN="0x6714f16fd59a9efc61aad6bdf36907809b5145c2ef63d496bfd07404d37232eb"
export CLOCK="0x6"

sui client call --package $PACKAGE_ID --module bitlist --function add_item --gas-budget 100000000 --args \
    $BITLIST_SHARE_OBJECT_ID \
    $TITLE \
    $BASE_AMOUNT \
    $COST_AMOUNT \
    $PUBLIC_CONTENT \
    $PRIVATE_CONTENT \
    $PAYMENT_COIN \
    $CLOCK
```

### 购买1
```
export ITEM_ID=0
export PAYMENT_COIN="0xc9263345a7790c751657a3f17d0d58d165c6e3651e23d85f33f01398e7e08b00"

sui client call --package $PACKAGE_ID --module bitlist --function purchase_item --gas-budget 100000000 --args \
    $BITLIST_SHARE_OBJECT_ID \
    $ITEM_ID \
    $PAYMENT_COIN

https://testnet.suivision.xyz/txblock/DwgRYws3FapXCEHcWd7Ln32vo6hrpSJPPiFq3KKpeS9M
```