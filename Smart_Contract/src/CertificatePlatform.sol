// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CertificatePlatform is ERC721URIStorage, Ownable{

    //events
    event IssuerRegistered(address indexed newIssuer);
    event CertificateIssued(uint256 indexed tokenId, address recipient);
    event Claimed(address indexed recipient, uint256 tokenId);
    event RevokedCertificated(uint256 indexed tokenId);

    //state variables
    mapping(address => bool) private RegisteredIssuer;
    mapping(uint256 => bool) private RevokedCertificate;
    mapping(uint256 => Certificate) private Certificates;
    
    struct Certificate{
       address recipient;
       address issuer;
       string metadataUri;
       bool claimed;
    }

    constructor() ERC721("CertificateOfCompletion", "CC") Ownable(msg.sender){}

    modifier onlyRegisteredIssuer{
        require(RegisteredIssuer[msg.sender], "issuer not registered");
        _;
    }

    function registerIssuer(address _newIssuer) external onlyOwner {
        require(!RegisteredIssuer[_newIssuer], "registered issuer already");
        RegisteredIssuer[_newIssuer] = true;
        emit IssuerRegistered(_newIssuer);
    }

    ///@param _tokenId are  ( MAT numbers or phone number etc) something unique
    ///@param _metadataUri url provided by issuer
    function issueCertificate(string memory _metadataUri, uint256 _tokenId, address _recipient) external onlyRegisteredIssuer {
        require(Certificates[_tokenId].issuer == address(0), "certificate already issued");
        Certificates[_tokenId] = Certificate({
            recipient:_recipient,
            issuer: msg.sender,
            metadataUri:_metadataUri,
            claimed :false
        });
        emit CertificateIssued(_tokenId, _recipient);
    }

    function claimCertificate(uint256 _tokenId) external {
        address recipient = Certificates[_tokenId].recipient;
        require(Certificates[_tokenId].issuer != address(0), "Certificate does not exist");
        require(recipient == msg.sender, "not eligible");
        require(!Certificates[_tokenId].claimed, "already claimed Certificate");
        string memory metadataUri = Certificates[_tokenId].metadataUri;
        Certificates[_tokenId].claimed = true;
        _safeMint(recipient, _tokenId);
        _setTokenURI(_tokenId, metadataUri);
        emit Claimed(recipient, _tokenId);
    }

    function revokeCertificate(uint256 _tokenId) external onlyRegisteredIssuer{
        require(Certificates[_tokenId].issuer == msg.sender, "only issuer can revoke certificate");
        require(!RevokedCertificate[_tokenId], "certificate already revoked");
        RevokedCertificate[_tokenId] = true;
        emit RevokedCertificated(_tokenId);
    }

    function verifyCertificate(uint256 _tokenId) external view returns(bool isValid,address recipient, string memory metadataUri){
        require(Certificates[_tokenId].issuer != address(0), "Certificate does not exists");
        isValid = RevokedCertificate[_tokenId];
        recipient = Certificates[_tokenId].recipient;
        metadataUri = tokenURI(_tokenId);
    }

    function registeredIssuers(address _issuer) external view returns(bool){
        return RegisteredIssuer[_issuer];
    }

    function certificate(uint256 _tokenId) external view returns(Certificate memory){
        return Certificates[_tokenId];
    }

}

