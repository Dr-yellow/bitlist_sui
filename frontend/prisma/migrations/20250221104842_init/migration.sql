-- CreateTable
CREATE TABLE "Item" (
    "id" TEXT NOT NULL,
    "itemId" INTEGER NOT NULL,
    "owner" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "baseAmount" BIGINT NOT NULL,
    "costAmount" BIGINT NOT NULL,
    "publicContent" TEXT NOT NULL,
    "privateContent" TEXT NOT NULL,
    "createdAt" BIGINT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WithdrawalLog" (
    "id" TEXT NOT NULL,
    "amount" BIGINT NOT NULL,
    "recipient" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WithdrawalLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PurchaseLog" (
    "id" TEXT NOT NULL,
    "itemId" INTEGER NOT NULL,
    "buyer" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PurchaseLog_pkey" PRIMARY KEY ("id")
);
