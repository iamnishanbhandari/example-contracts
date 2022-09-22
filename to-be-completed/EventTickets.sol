// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;


contract EventTickets {

     address payable public owner;   //to get default getter function


    uint   TICKET_PRICE = 100 wei;

    struct Event{
        string description;
        string websiteUrl;
        uint256 totalTickets;
        uint256 sales;
        bool isOpen;
        mapping(address => uint) Buyers;

    }
    Event EventInstance;


    event LogBuyTickets(address indexed purchaser,uint256 numOfTickets);
    event LogGetRefund(address indexed requester,uint256 numOfTickets);
    event LogEndSale(address owner,uint256 balance);
    

    modifier onlyOwner{
        require(owner==msg.sender,"only owner can modify");
        _;
    }
    


    constructor (string memory _description,string memory _url,uint256 _Totaltickets) {
        owner=payable(msg.sender);
        EventInstance.description=_description;
        EventInstance.websiteUrl=_url;
        EventInstance.totalTickets=_Totaltickets;
        EventInstance.isOpen=true;

    }


    function readEvent()
        public view
        returns(string memory, string memory , uint , uint , bool)
    {
      string memory Description=EventInstance.description;
      string memory url=EventInstance.websiteUrl;
      uint256 totalTickets=EventInstance.totalTickets;
      uint256 sales=EventInstance.sales;
      bool isOpen=EventInstance.isOpen;
      return(Description,url,totalTickets,sales,isOpen);
    }

    function getBuyerTicketCount(address _buyer)public view returns(uint){
        return EventInstance.Buyers[_buyer];
    }


    function buyTickets(uint256 _numTickets)public payable {

      require(EventInstance.isOpen,"event is closed or not started");
      require(_numTickets <= EventInstance.totalTickets,"you cant buy more tickets than declared");
      require((_numTickets*TICKET_PRICE) <= msg.value,"insufficient amount");
      require(EventInstance.sales<EventInstance.totalTickets,"tickets are out of stock");

      EventInstance.Buyers[msg.sender]=_numTickets;
      EventInstance.totalTickets -= _numTickets;
      EventInstance.sales += _numTickets;

     uint surplusAmount=msg.value-(_numTickets*TICKET_PRICE);
     payable(msg.sender).transfer(surplusAmount);
     emit LogBuyTickets(msg.sender,_numTickets);



    }


    function getRefund()public{
      require(EventInstance.Buyers[msg.sender]>0,"you haven't purchased the tickets");
      uint amounToBeRefunded= EventInstance.Buyers[msg.sender]*TICKET_PRICE;
      uint refundTickets=EventInstance.Buyers[msg.sender];
      EventInstance.totalTickets += refundTickets;
      EventInstance.sales -= refundTickets;
      payable(msg.sender).transfer(amounToBeRefunded);
      
      emit LogGetRefund(msg.sender,refundTickets);


    }


    function endSale()public onlyOwner{
      owner.transfer(address(this).balance);
      EventInstance.isOpen=false;
      emit LogEndSale(owner,address(this).balance);
    }
}
