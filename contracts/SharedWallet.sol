pragma solidity 0.7.5;

contract SharedWallet {
     
      address private _owner;
      mapping(address => uint8) private _owners;

      modifier isOwner(){
          require(msg.sender==_owner);
          _;
      }

      modifier validOwner() {
          require(msg.sender==_owner || _owners[msg.sender]==1);
          _;
      }

      event DepositFunds(address from, uint amount);
      event WithdrawFunds(address from, uint amount);
      event TransferFunds(address from, address to, uint amount);

      constructor() {
          _owner = msg.sender;
      }

      function addOwner(address addr) isOwner external {
           require(addr != address(0), "invalid address");
           _owners[addr] = 1;
      }

      function removeOwner(address addr) isOwner external {
          require(addr != address(0), "invalid address");
          _owners[addr] = 0;
      }

      receive () external payable {
         emit DepositFunds(msg.sender, msg.value);
      }

      function withdraw(uint amount) validOwner() external {
          require(address(this).balance >= amount, "insufficient balance");
          msg.sender.transfer(amount);
          emit WithdrawFunds(msg.sender, amount);
      }

      function transferTo(address payable to, uint amount) validOwner() external {
            require(address(this).balance >= amount, "insufficient balance");
            to.transfer(amount);
            emit TransferFunds(msg.sender, to,  amount);
      }
 }