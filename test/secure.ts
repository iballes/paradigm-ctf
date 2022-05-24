import { expect } from "chai";
import { Contract, Signer } from "ethers";
import { ethers } from "hardhat";
import { getContractFactory } from "hardhat/types";
import { deployOrGetAt, getEoaOrPrivateKey } from "./utils";

let accounts: Signer[];
let eoa: Signer;
let eoaAddress: string;
let attacker: Contract;
let setup: Contract; // setup contract
let token: Contract;
let pair: Contract;
let broker: Contract;
let tx: any;

before(async () => {
  eoa = await getEoaOrPrivateKey(
    `0x3dd8959b306473ead211fb0f1d330d0870007f100cf824c15af3c582e1249ff4`
  );
  eoaAddress = await eoa.getAddress();

  setup = await deployOrGetAt(
    `contracts/secure/public/contracts/Setup.sol:Setup`,
    `0x02f0572a7D8322A2506b96C25cF81a39B6db726B`,
    eoa,
    { value: ethers.utils.parseEther(`50`) }
  );
});

it("solves the challenge", async function () {
  // attacker: 50eth
  this.attackerContract = await (await ethers.getContractFactory('SecureAttackerIballes', attacker)).deploy(
    setup.address
  );
  await this.attackerContract.attack({value: ethers.utils.parseEther('50')});

  // PCTF{7h1nk1ng_0U751dE_7he_80X}
});

after(async function (){
  expect(await setup.isSolved()).to.be.equal(true);
});
