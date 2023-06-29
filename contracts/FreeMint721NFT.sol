pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Governable.sol";

contract FreeMint721NFT is Governable, ERC721 {
    event Mint(address indexed owner, uint256 indexed tokenId);

    uint256 private _counter;
    uint256 private _maxAmount;
    uint256 private _startTime;
    uint256 private _endTime;
    uint256 private _userLimit;
    uint256 private _mintPrice;
    address private _acceptCurrency;

    mapping(address => uint256) public userMinted;
    address ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 maxAmount,
        uint256 startTime,
        uint256 endTime,
        uint256 userLimit,
        address acceptCurrency,
        uint256 mintPrice
    ) public ERC721(name, symbol) {
        string memory addressStr = _toAsciiString(address(this));
        _setBaseURI(string(abi.encodePacked(baseURI, "0x", addressStr, "/")));
        _maxAmount = maxAmount;
        _startTime = startTime;
        _endTime = endTime;
        _userLimit = userLimit;
        _mintPrice = mintPrice;
        _acceptCurrency = acceptCurrency;
        super.initialize(msg.sender);
    }

    function _toAsciiString(address x) private pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(
                uint8(uint256(uint160(x)) / (2 ** (8 * (19 - i))))
            );
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = _char(hi);
            s[2 * i + 1] = _char(lo);
        }
        return string(s);
    }

    function _char(bytes1 b) private pure returns (bytes1 c) {
        if (uint8(b) < 10) {
            return bytes1(uint8(b) + 0x30);
        } else {
            return bytes1(uint8(b) + 0x57);
        }
    }

    function setBaseURI(
        string memory baseURI
    ) external governance returns (bool) {
        _setBaseURI(baseURI);
    }
    function setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) external governance returns (bool) {
        _setTokenURI(tokenId, _tokenURI);
    }
    function setMaxAmount(uint256 maxAmount) external governance {
        _maxAmount = maxAmount;
    }
    function setStartTime(uint256 startTime) external governance {
        _startTime = startTime;
    }
    function setEndTime(uint256 endTime) external governance {
        _endTime = endTime;
    }
    function setUserLimit(uint256 userLimit) external governance {
        _userLimit = userLimit;
    }
    function setMintPrice(uint256 mintPrice) external governance {
        _mintPrice = mintPrice;
    }
    function setAcceptCurrency(address acceptCurrency) external governance {
        _acceptCurrency = acceptCurrency;
    }

    function mint() public payable {
        require(_counter < _maxAmount, "Exceed maximum");
        require(_startTime < now, "no start");
        require(_endTime > now, "is end");
        require(userMinted[msg.sender] < _userLimit, "Exceed limit");

        if (_mintPrice > 0) {
          if (_acceptCurrency == ZERO_ADDRESS) {
              require(msg.value >= _mintPrice, "Insufficient funds");
          } else {
              IERC20(_acceptCurrency).transferFrom(msg.sender, address(this), _mintPrice);
          }
        }

        _counter += 1;
        userMinted[msg.sender] += 1;
        _mint(msg.sender, _counter);
        emit Mint(msg.sender, _counter);
    }

    function claimTokenTo(address token, uint256 amount, address to) external governance {
        if (token == ZERO_ADDRESS) {
            payable(to).transfer(amount);
        } else {
            IERC20(token).transfer(to, amount);
        }
    }
}
