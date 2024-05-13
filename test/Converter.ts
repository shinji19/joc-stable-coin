import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Converter", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployConverterFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const YenFT = await hre.ethers.getContractFactory("Yen");
    const yenFT = await YenFT.deploy(owner);
    await yenFT.connect(owner).activate();
    await yenFT.connect(otherAccount).activate();

    const YenNFT = await hre.ethers.getContractFactory("YenNotesAndCoins");
    const yenNFT = await YenNFT.deploy(owner);
    await yenNFT.updateValueKinds([1000 * 10^18]);

    const Converter = await hre.ethers.getContractFactory("Converter");
    const converter = await Converter.deploy(await yenFT.getAddress(), await yenNFT.getAddress());

    await yenFT.grantRole(await yenFT.MINTER_ROLE(), await converter.getAddress());
    await yenFT.grantRole(await yenFT.MINTER_ROLE(), owner);
    await yenNFT.grantRole(await yenFT.MINTER_ROLE(), await converter.getAddress());
    await yenNFT.grantRole(await yenFT.MINTER_ROLE(), owner);

    return { yenFT, yenNFT, converter, owner, otherAccount };
  }

  describe("ft2nft", function () {
    it("Should convert", async function () {
      const { 
        yenFT, yenNFT, converter,
        owner, otherAccount
        } = await loadFixture(deployConverterFixture);
      await yenFT.mint(otherAccount, 1000 * 10^18);
      await yenFT.connect(otherAccount).approve(
        await converter.getAddress(), 
        1000 * 10^18);
      await converter.connect(otherAccount).ft2nft(1000 * 10^18);
      expect(await yenNFT.ownerOf(0)).to.equal(otherAccount);
      expect(await yenNFT.getValue(0)).to.equal(1000 * 10^18);
    });
  });

  describe("nft2ft", function () {
    it("Should convert", async function () {
      const { 
        yenFT, yenNFT, converter,
        owner, otherAccount
        } = await loadFixture(deployConverterFixture);
      await yenNFT.mint(otherAccount, 1000 * 10^18);
      await yenNFT.connect(otherAccount).approve(
        await converter.getAddress(), 0);
      await converter.connect(otherAccount).nft2ft(0);
      expect(await yenFT.balanceOf(otherAccount)).to.equal(1000 * 10^18);
    });
  });
});
