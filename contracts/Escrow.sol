pragma solidity ^0.8.0;

contract Escrow {
    struct EscrowDetail {
        address seller;
        address buyer;
        uint256 amount;
        uint256 fee;
        string status; // "created", "released", "cancelled"
    }

    address public owner;
    address public arbitrator;
    address public relayer;
    address public withdrawalAddress;

    uint256 public platformFees;
    uint256 public escrowCounter;

    mapping(uint256 => EscrowDetail) public escrows;

    event EscrowCreated(uint256 escrowId, address indexed buyer, uint256 amount);
    event EscrowReleased(uint256 escrowId);
    event EscrowCancelled(uint256 escrowId);
    event DisputeResolved(uint256 escrowId, address recipient);
    event FeesSwept(uint256 amount);
    event FeesWithdrawn(address to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Not arbitrator");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createEscrow(address buyer, uint256 amount) external payable {
        require(msg.value == amount, "Amount mismatch");
        escrowCounter++;
        escrows[escrowCounter] = EscrowDetail({
            seller: msg.sender,
            buyer: buyer,
            amount: amount,
            fee: amount / 100, // 1% fee
            status: "created"
        });
        emit EscrowCreated(escrowCounter, buyer, amount);
    }

    function releaseEscrow(uint256 escrowId) external {
        EscrowDetail storage escrow = escrows[escrowId];
        require(msg.sender == escrow.seller, "Not seller");
        require(keccak256(bytes(escrow.status)) == keccak256("created"), "Invalid status");

        escrow.status = "released";
        uint256 fee = escrow.fee;
        uint256 payment = escrow.amount - fee;

        payable(escrow.buyer).transfer(payment);
        platformFees += fee;

        emit EscrowReleased(escrowId);
    }

    function cancelEscrow(uint256 escrowId) external {
        EscrowDetail storage escrow = escrows[escrowId];
        require(msg.sender == escrow.seller, "Not seller");
        require(keccak256(bytes(escrow.status)) == keccak256("created"), "Invalid status");

        escrow.status = "cancelled";
        payable(escrow.seller).transfer(escrow.amount);

        emit EscrowCancelled(escrowId);
    }

    function resolveDispute(uint256 escrowId, address recipient) external onlyArbitrator {
        EscrowDetail storage escrow = escrows[escrowId];
        require(keccak256(bytes(escrow.status)) == keccak256("created"), "Invalid status");

        escrow.status = "cancelled";
        payable(recipient).transfer(escrow.amount);
        emit DisputeResolved(escrowId, recipient);
    }

    function setArbitrator(address _arbitrator) external onlyOwner {
        arbitrator = _arbitrator;
    }

    function setWithdrawalAddress(address _withdrawalAddress) external onlyOwner {
        withdrawalAddress = _withdrawalAddress;
    }

    function sweepFees() external onlyOwner {
        uint256 fees = platformFees;
        platformFees = 0;
        payable(withdrawalAddress).transfer(fees);
        emit FeesSwept(fees);
    }

    function withdrawFees() external onlyOwner {
        uint256 fees = platformFees;
        platformFees = 0;
        payable(msg.sender).transfer(fees);
        emit FeesWithdrawn(msg.sender, fees);
    }
}
