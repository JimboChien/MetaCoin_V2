
pragma solidity >=0.4.25 <0.7.0;

contract MetaCoin_V2 {
	
	mapping (address => uint) balances;
	
	// Original MetaCoin Function
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	
	constructor() public {
		balances[tx.origin] = 10000;
	}
	
	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		return true;
	}
	
	/*
	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}
	*/
	
	function getCoinBalance(address addr) public view returns(uint) {
		return balances[addr];
	}
	
	// New Function
	function ether2Coin() payable external {
		// 1 Ether to 1 MetaCoin
		// Must Integer Ether And At Least 1 Ether
		require(msg.value % 1 ether == 0 && msg.value >= 1 ether);
		balances[msg.sender] += msg.value / 1 ether;
	}
	
	function coin2Ether(uint amount) external {
		// Request Amount Must More Than Balance
		require(balances[msg.sender] >= amount);
		balances[msg.sender] -= amount;
		msg.sender.transfer(amount * 1 ether);
	}
	
	function getSmartContractBalance() external view returns(uint) {
		return address(this).balance;
	}
}
