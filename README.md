# MetaCoin_V2

將原本 [MetaCoin](https://github.com/truffle-box/metacoin-box) 新增功能。

## 變數
1. `balances` : 紀錄 **MetaCoin** 餘額。
```solidity
mapping (address => uint) balances;
```

2. 初始 **MetaCoin** 數量 : 設定為限量 <font color="red">10000</font> 個 **MetaCoin**。
```solidity
constructor() public {
    balances[tx.origin] = 10000;
}
```

## 原 **MetaCoin** 功能
1. `sendCoin` : 將 **MetaCoin** 轉移至指定地址。
```solidity
function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
    if (balances[msg.sender] < amount) return false;
    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    emit Transfer(msg.sender, receiver, amount);
    return true;
}
```

2. `getBalanceInEth` : 將指定地址的 **MetaCoin** 乘以 2，此功能將不會用到，因此註解掉。
```solidity
/*
function getBalanceInEth(address addr) public view returns(uint){
    return ConvertLib.convert(getBalance(addr),2);
}
*/
```

3. `getCoinBalance` (原功能名稱為 `getBalance`) : 取得指定地址的 **MetaCoin** 數。
```solidity
function getCoinBalance(address addr) public view returns(uint) {
    return balances[addr];
}
```

## 新增功能
1. `ether2Coin` : 以 **Ether** 購買 **MetaCoin** (1 **Ether** = 1 **MetaCoin**)。
```solidity
function ether2Coin() payable external {
    // 1 Ether to 1 MetaCoin
    // Must Integer Ether And At Least 1 Ether
    require(msg.value % 1 ether == 0 && msg.value >= 1 ether);
    balances[msg.sender] += msg.value / 1 ether;
}
```

2. `coin2Ether` : 以 **MetaCoin** 贖回 **Ether**。
```solidity
function coin2Ether(uint amount) external {
    // Request Amount Must More Than Balance
    require(balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;
    msg.sender.transfer(amount * 1 ether);
}
```

3. `getSmartContractBalance` : 取得智能合約中所擁有的 **Ether**。
```solidity
function getSmartContractBalance() external view returns(uint) {
    return address(this).balance;
}
```
