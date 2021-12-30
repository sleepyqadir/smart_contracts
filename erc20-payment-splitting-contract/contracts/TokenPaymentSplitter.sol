pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


abstract contract TokenPaymentSplitter {
    using SafeERC20 for IERC20;


    address internal paymentToken;
    uint256 internal totalShares;
    uint256 internal totalTokenReleased;
    address[] internal payees;

    mapping(address =>uint256) internal shares;
    mapping(address =>uint256) internal tokenReleased;


    constructor(address[] memory _payees, uint256[] memory shares_, address token) payable {
        require(_payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
        require(_payees.length > 0, "PaymentSplitter: no payees");

        for (uint256 i = 0; i < payees.length; i++) {
            _addPayee(_payees[i], shares_[i]);
        }
        paymentToken = token;
    }


    event PayeeAdded(address account, uint256 shares);
    event PaymentReleased(address to, uint256 amount);

    function getTotalShares() public view returns (uint256){
        return totalShares;
    }

    function getSingleShares( address account) public view returns (uint256){
        return shares[account];
    }

    function getPayee(uint256 index) public view returns (address){
        return payees[index];
    }

    function _addPayee(address account, uint256 shares_) internal {
        require(shares_ > 0, "TokenPaymentSplitter: Shares must be greater than 0");
        require(account != address(0), "TokenPaymentSplitter: account must not be 0 address");
        require(shares[account] == 0, "TokenPaymentSplitter: account already has shares");

        shares[account] = shares_;
        payees.push(account);
        totalShares = totalShares + shares_;

        emit PayeeAdded(account, shares_);
    }

    function released(address account) public view returns (uint256) {
        return tokenReleased[account];
    }

    function release(address account) public virtual {
        require(shares[account] == 0, "TokenPaymentSplitter: account has 0 shares");
        uint256 tokenTotalRecieved = IERC20(paymentToken).balanceOf(address(this)) + totalTokenReleased;

        uint256 payment = _pendingPayment(account, tokenTotalRecieved, released(account));
        require(payment != 0, "TokenPaymentSplitter: account has 0 payment due");
        tokenReleased[account] = tokenReleased[account] + payment;
        totalTokenReleased = totalTokenReleased + payment;
        IERC20(paymentToken).safeTransfer(account, payment);

        emit PaymentReleased(account, payment);
    }

     /**
     * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
     * already released amounts.
     */
    function _pendingPayment(
        address account,
        uint256 totalReceived,
        uint256 alreadyReleased
    ) private view returns (uint256) {
        return (totalReceived * shares[account]) / totalShares - alreadyReleased;
    }
}