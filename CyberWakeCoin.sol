pragma solidity 0.6.6;



contract CyberWakeCoin{

	int balance;

	
	constructor() public{

        	balance = 0;
    
	}

    
    
	function getBalance()view public returns(int){

	        return balance;
    
	}

    
    
	function depositBalance(int amt)public{

	        balance = balance + amt;
	
}


    
    function withdrawBalance(int amt)public{

        balance = balance - amt;
    
	}

}