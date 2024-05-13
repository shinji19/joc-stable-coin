import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const YenModule = buildModule("YenModule", (m) => {
    const yen = m.contract("Yen", [m.getAccount(0)]);
    return { yen };
});

const YenNotesAndCoinsModule = buildModule("YenNotesAndCoinsModule", (m) => {
    const yenNotesAndCoins = m.contract("YenNotesAndCoins", [m.getAccount(0)]);
    return { yenNotesAndCoins };
});

const ConverterModule = buildModule("ConverterModule", (m) => {
    const { yen } = m.useModule(YenModule);
    const { yenNotesAndCoins } = m.useModule(YenNotesAndCoinsModule);

    const converter = m.contract(
        "Converter",
        [yen, yenNotesAndCoins]);

    {
        const minterRole = m.staticCall(yen, "MINTER_ROLE");
        m.call(
            yen, 
            "grantRole", 
            [minterRole, m.getAccount(0)],
            {id: "grant_owner"}
        );
        m.call(
            yen, 
            "grantRole", 
            [minterRole, converter],
            {id: "grant_converter"}
        );
    }

    {
        const minterRole = m.staticCall(
            yenNotesAndCoins, "MINTER_ROLE");

        m.call(
            yenNotesAndCoins, 
            "grantRole", 
            [minterRole, m.getAccount(0)],
            {id: "nft_grant_owner"}
        );
    
        m.call(
            yenNotesAndCoins, 
            "grantRole", 
            [minterRole, converter],
            {id: "nft_grant_converter"}
        );
    }
   
    return { converter };
});

export default ConverterModule;
