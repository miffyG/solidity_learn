// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BeggingContraact {
    // 合约所有者地址
    address private immutable _owner;
    //记录每个捐赠者的地址和金额
    mapping(address => uint256) private _donations;
    // 排行榜前3
    address[3] public topDonors;
    uint256[3] public topDonations;
    // 捐赠时间限制
    uint256 public donationStartTime;
    uint256 public donationEndTime;

    modifier onlyOwner() {
        require(
            msg.sender == _owner,
            "Only contract owner can call this function"
        );
        _;
    }

    //Events
    event Donation(address indexed donor, uint256 amount, string method);

    //Errors
    error InsufficientFund(address owner, uint256 balance);
    error DonationNotActive();

    constructor() {
        _owner = msg.sender;
        donationStartTime = block.timestamp;
        donationEndTime = block.timestamp + 30 minutes;
    }

    // 用户捐赠并记录捐赠信息
    function donate() external payable {
        if (
            block.timestamp >= donationStartTime &&
            block.timestamp <= donationEndTime
        ) {
            _donations[msg.sender] += msg.value;
            _updateTopDonors(msg.sender, _donations[msg.sender]);
            emit Donation(msg.sender, msg.value, "donate()");
        } else {
            revert DonationNotActive();
        }
    }

    // 合约所有者提取所有资金
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance <= 0) {
            revert InsufficientFund(address(this), balance);
        }
        payable(_owner).transfer(balance);
    }

    // 查询某个地址的捐赠金额
    function getDonation(address donor) external view returns (uint256) {
        return _donations[donor];
    }

    // 获取捐赠排行榜前3名
    function getTopDonnors()
        external
        view
        returns (address[3] memory, uint256[3] memory)
    {
        return (topDonors, topDonations);
    }

    // 更新捐赠排行榜
    function _updateTopDonors(address donor, uint256 totalDonation) private {
        // 1. 检查捐赠者是否已在排行榜中，若在则更新金额并重新排序
        for (uint8 i = 0; i < 3; i++) {
            if (topDonors[i] == donor) {
                topDonations[i] = totalDonation;
                _sortTopDonors();
                return;
            }
        }

        // 2. 若不在排行榜中，且金额超过当前第三名，则加入并排序
        if (totalDonation > topDonations[2]) {
            topDonors[2] = donor;
            topDonations[2] = totalDonation;
            _sortTopDonors();
        }
    }

    function _sortTopDonors() private {
        if (topDonations[0] < topDonations[1]) {
            (topDonors[0], topDonors[1]) = (topDonors[1], topDonors[0]);
            (topDonations[0], topDonations[1]) = (
                topDonations[1],
                topDonations[0]
            );
        }
        if (topDonations[1] < topDonations[2]) {
            (topDonors[1], topDonors[2]) = (topDonors[2], topDonors[1]);
            (topDonations[1], topDonations[2]) = (
                topDonations[2],
                topDonations[1]
            );
        }
        if (topDonations[0] < topDonations[1]) {
            (topDonors[0], topDonors[1]) = (topDonors[1], topDonors[0]);
            (topDonations[0], topDonations[1]) = (
                topDonations[1],
                topDonations[0]
            );
        }
    }

    // 允许用户直接向合约发送以太币，并记录捐赠信息
    receive() external payable {
        if (
            block.timestamp >= donationStartTime &&
            block.timestamp <= donationEndTime
        ) {
            _donations[msg.sender] += msg.value;
            _updateTopDonors(msg.sender, _donations[msg.sender]);
            emit Donation(msg.sender, msg.value, "receive()");
        } else {
            revert DonationNotActive();
        }
    }
}
