contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

contract Authority is Ownable {
    mapping(address => bool) keys;
    mapping(address => bool) keyOwners;
    mapping(address => bool) blessings;
    
    modifier onlyKeyholders() {
        require(keys[msg.sender]);
        _;
    }
    
    modifier onlyNonKeyholders() {
        require(!keys[msg.sender]);
        _;
    }
    
    // The message sender is the initial key holder
    constructor() public {
        keys[msg.sender] = true;
    }
    
    // Any key owner can add a key
    function addKey(address key) onlyKeyholders {
        keys[key] = true;
        keyOwners[key] = msg.sender;
    }
    
    // Only the address that added the key can remove it
    function removeKey(address key) onlyKeyholders {
        require(keyOwners[key] == msg.sender);
        keys[key] == false;
    }
    
    // Blessings give an authority more credit because authorities themselves
    // can vouch for them.
    function bless() onlyNonKeyholders() {
        blessings[msg.sender] == true;
    }
    
    // Authorities can remove their blessings as well.
    function unbless() onlyNonKeyholders() {
        require(blessings[msg.sender]);
        blessings[msg.sender] == false;
    }
    
}
