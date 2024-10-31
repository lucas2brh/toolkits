import { ethers } from 'ethers';
import dotenv from "dotenv"
import upgradeEntrypointABI from "../abi/UpgradeEntrypoint.abi.json";
dotenv.config()

// run the test with name and height parameters
// example: npx ts-node tests/upgrade.test.ts "v0.10.0" 1000 "0xYOURPRIVATEKEY"
;(async () => {
    const name = process.argv[2];
    const height = parseInt(process.argv[3], 10);
    const privateKey = process.argv[4];

    const RPC_URL = process.env.JSON_RPC_PROVIDER_URL as string;
    const upgradeEntrypointAddress = "0xCCCCCC0000000000000000000000000000000003";

    if (!name || isNaN(height)) {
        console.error("Please provide valid name and height parameters.");
        process.exit(1);
    }
    console.log(`Upgrading with name: ${name} and height: ${height} on ${RPC_URL}`);

    const provider = new ethers.JsonRpcProvider(RPC_URL);
    const signer = new ethers.Wallet(privateKey, provider);
    
    // Contract
    const upgradeEntrypoint = new ethers.Contract(upgradeEntrypointAddress, upgradeEntrypointABI, signer);

    const upgrade = new ethers.Contract(
        upgradeEntrypoint,
        upgradeEntrypointABI,
        signer
    );
    console.log(`Sender address: ${signer.address}`);
    // plan upgrade with name, height and info
    const tx = await upgrade.planUpgrade(name, height, '');

    await tx.wait();
    console.log("hash", tx.hash);
})();
