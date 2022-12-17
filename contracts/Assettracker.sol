pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract AssetTracking {
    using SafeMath for uint;

    // Struct for an asset
    struct Asset {
        string id;
        string name;
        string owner;
        string location;
        uint value;
    }

    // Mapping from asset ID to asset struct
    mapping (string => Asset) public assets;

    // Function to add a new asset
    function addAsset(string memory id, string memory name, string memory owner, string memory location, uint value) public {
        // Check that the asset does not already exist
        require(assets[id] == Asset(0, 0, 0, 0, 0), "Asset already exists.");

        // Add the asset
        assets[id] = Asset(id, name, owner, location, value);

        // Emit the AssetAdded event
        emit AssetAdded(id, name, owner, location, value);
    }

    // Function to update the location of an asset
    function updateLocation(string memory id, string memory location) public {
        // Check that the asset exists
        require(assets[id] != Asset(0, 0, 0, 0, 0), "Asset does not exist.");

        // Update the location of the asset
        assets[id].location = location;

        // Emit the LocationUpdated event
        emit LocationUpdated(id, location);
    }

    // Function to transfer ownership of an asset
    function transferOwnership(string memory id, string memory newOwner) public {
        // Check that the asset exists
        require(assets[id] != Asset(0, 0, 0, 0, 0), "Asset does not exist.");

        // Update the owner of the asset
        assets[id].owner = newOwner;

        // Emit the OwnershipTransferred event
        emit OwnershipTransferred(id, newOwner);
    }

    // Event for when an asset is added
    event AssetAdded(string id, string name, string owner, string location, uint value);

    // Event for when the location of an asset is updated
    event LocationUpdated(string id, string location);

    // Event for when the ownership of an asset is transferred
    event OwnershipTransferred(string id, string newOwner);
}
