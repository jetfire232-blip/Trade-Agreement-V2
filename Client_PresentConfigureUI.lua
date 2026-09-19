-- =========================================================
-- GLOBAL ECONOMY & DIPLOMACY
-- HOST CONFIGURATION UI
-- =========================================================

TradeConfigInputs = {};


-- =========================================================
-- HELPERS
-- =========================================================

local function GetNumberSetting(settings, name, defaultValue)

    if settings[name] ~= nil then
        return settings[name];
    end

    return defaultValue;
end


local function GetBoolSetting(settings, name, defaultValue)

    if settings[name] ~= nil then
        return settings[name];
    end

    return defaultValue;
end


local function AddDivider(root)

    UI.CreateLabel(root)
        .SetText(
            "----------------------------------------"
        );
end


local function AddSection(root, title, description)

    AddDivider(root);

    UI.CreateLabel(root)
        .SetText(
            title
        );

    if description ~= nil
        and description ~= "" then

        UI.CreateLabel(root)
            .SetText(
                description
            );
    end
end


local function AddNumberInput(
    root,
    key,
    label,
    value,
    minimum,
    maximum,
    helpText
)

    UI.CreateLabel(root)
        .SetText(
            label
        );

    TradeConfigInputs[key] =
        UI.CreateNumberInputField(root)
            .SetWholeNumbers(true)
            .SetSliderMinValue(minimum)
            .SetSliderMaxValue(maximum)
            .SetValue(
                value
            );

    if helpText ~= nil
        and helpText ~= "" then

        UI.CreateLabel(root)
            .SetText(
                helpText
            );
    end
end


local function AddCheckBox(
    root,
    key,
    label,
    checked
)

    TradeConfigInputs[key] =
        UI.CreateCheckBox(root)
            .SetText(
                label
            )
            .SetIsChecked(
                checked
            );
end


-- =========================================================
-- MAIN CONFIGURATION UI
-- =========================================================

function Client_PresentConfigureUI(rootParent)

    local root =
        UI.CreateVerticalLayoutGroup(
            rootParent
        );

    local settings =
        Mod.Settings or {};


    -- =====================================================
    -- CURRENT / EXISTING TRADE SETTINGS
    -- =====================================================

    local maxTradeAgreements =
        GetNumberSetting(
            settings,
            "MaxTradeAgreements",
            3
        );

    local tradeBonusPercent =
        GetNumberSetting(
            settings,
            "TradeBonusPercent",
            10
        );

    local tradeCooldownTurns =
        GetNumberSetting(
            settings,
            "TradeCooldownTurns",
            3
        );

    local aiProposalChance =
        GetNumberSetting(
            settings,
            "AIProposalChance",
            35
        );

    local aiMinimumAgreementTurns =
        GetNumberSetting(
            settings,
            "AIMinimumAgreementTurns",
            3
        );

    local aiReplacementPercent =
        GetNumberSetting(
            settings,
            "AIReplacementPercent",
            50
        );

    local economicDeclineTurns =
        GetNumberSetting(
            settings,
            "EconomicDeclineTurns",
            3
        );


    -- =====================================================
    -- CURRENT / EXISTING AI INVESTMENT SETTINGS
    -- =====================================================

    local aiInvestmentsEnabled =
        GetBoolSetting(
            settings,
            "AIInvestmentsEnabled",
            true
        );

    local aiProjectsEnabled =
        GetBoolSetting(
            settings,
            "AIProjectsEnabled",
            true
        );

    local aiProjectChance =
        GetNumberSetting(
            settings,
            "AIProjectChance",
            15
        );

    local aiInvestChance =
        GetNumberSetting(
            settings,
            "AIInvestChance",
            30
        );

    local aiInvestmentReservePercent =
        GetNumberSetting(
            settings,
            "AIInvestmentReservePercent",
            40
        );


    -- =====================================================
    -- GENERAL SETTINGS
    -- =====================================================

    local openingPeriodTurns =
        GetNumberSetting(
            settings,
            "OpeningPeriodTurns",
            1
        );

    local turnReportsEnabled =
        GetBoolSetting(
            settings,
            "TurnReportsEnabled",
            true
        );

    local worldNewsEnabled =
        GetBoolSetting(
            settings,
            "WorldNewsEnabled",
            true
        );


    -- =====================================================
    -- DIPLOMACY SETTINGS
    -- =====================================================

    local requireWarDeclaration =
        GetBoolSetting(
            settings,
            "RequireWarDeclaration",
            true
        );

    local playersStartAtWar =
        GetBoolSetting(
            settings,
            "PlayersStartAtWar",
            false
        );

    local warDeclarationDelay =
        GetNumberSetting(
            settings,
            "WarDeclarationDelay",
            1
        );

    local peaceCooldownTurns =
        GetNumberSetting(
            settings,
            "PeaceCooldownTurns",
            3
        );

    local nonAggressionPactsEnabled =
        GetBoolSetting(
            settings,
            "NonAggressionPactsEnabled",
            true
        );

    local giftWarRestrictionEnabled =
        GetBoolSetting(
            settings,
            "GiftWarRestrictionEnabled",
            true
        );

    local aiCanDeclareWarOnHumans =
        GetBoolSetting(
            settings,
            "AICanDeclareWarOnHumans",
            true
        );

    local aiCanDeclareWarOnAI =
        GetBoolSetting(
            settings,
            "AICanDeclareWarOnAI",
            true
        );


    -- =====================================================
    -- INVESTMENT SETTINGS
    -- =====================================================

    local investmentFundingWindow =
        GetNumberSetting(
            settings,
            "InvestmentFundingWindow",
            3
        );

    local internationalInvestorBonusEnabled =
        GetBoolSetting(
            settings,
            "InternationalInvestorBonusEnabled",
            true
        );

    local investorSuccessBonusPercent =
        GetNumberSetting(
            settings,
            "InvestorSuccessBonusPercent",
            3
        );

    local maxInvestorSuccessBonusPercent =
        GetNumberSetting(
            settings,
            "MaxInvestorSuccessBonusPercent",
            10
        );


    -- =====================================================
    -- STOCK MARKET SETTINGS
    -- =====================================================

    local stockMarketEnabled =
        GetBoolSetting(
            settings,
            "StockMarketEnabled",
            true
        );

    local maxCompaniesPerNation =
        GetNumberSetting(
            settings,
            "MaxCompaniesPerNation",
            3
        );

    local founderSharePercent =
        GetNumberSetting(
            settings,
            "FounderSharePercent",
            20
        );

    local dividendsEnabled =
        GetBoolSetting(
            settings,
            "DividendsEnabled",
            true
        );

    local dividendFrequencyTurns =
        GetNumberSetting(
            settings,
            "DividendFrequencyTurns",
            3
        );

    local stockVolatilityPercent =
        GetNumberSetting(
            settings,
            "StockVolatilityPercent",
            10
        );


    -- =====================================================
    -- ETF SETTINGS
    -- =====================================================

    local etfEnabled =
        GetBoolSetting(
            settings,
            "ETFEnabled",
            true
        );

    local etfSize =
        GetNumberSetting(
            settings,
            "ETFSize",
            5
        );

    local etfMembershipBonusPercent =
        GetNumberSetting(
            settings,
            "ETFMembershipBonusPercent",
            3
        );

    local etfLoyaltyBonusEnabled =
        GetBoolSetting(
            settings,
            "ETFLoyaltyBonusEnabled",
            true
        );


    -- =====================================================
    -- BOND SETTINGS
    -- =====================================================

    local bondsEnabled =
        GetBoolSetting(
            settings,
            "BondsEnabled",
            true
        );

    local minimumBondDuration =
        GetNumberSetting(
            settings,
            "MinimumBondDuration",
            2
        );

    local maximumBondDuration =
        GetNumberSetting(
            settings,
            "MaximumBondDuration",
            10
        );


    -- =====================================================
    -- TAXATION SETTINGS
    -- =====================================================

    local taxationEnabled =
        GetBoolSetting(
            settings,
            "TaxationEnabled",
            true
        );

    local taxChangeCooldownTurns =
        GetNumberSetting(
            settings,
            "TaxChangeCooldownTurns",
            2
        );


    -- =====================================================
    -- UNITED NATIONS SETTINGS
    -- =====================================================

    local unitedNationsEnabled =
        GetBoolSetting(
            settings,
            "UnitedNationsEnabled",
            true
        );

    local unitedNationsStartTurn =
        GetNumberSetting(
            settings,
            "UnitedNationsStartTurn",
            2
        );

    local unVoteDurationTurns =
        GetNumberSetting(
            settings,
            "UNVoteDurationTurns",
            2
        );

    local unPassRequirementPercent =
        GetNumberSetting(
            settings,
            "UNPassRequirementPercent",
            60
        );

    local unProposalCooldownTurns =
        GetNumberSetting(
            settings,
            "UNProposalCooldownTurns",
            2
        );

    local unMaximumActiveResolutions =
        GetNumberSetting(
            settings,
            "UNMaximumActiveResolutions",
            3
        );

    local aiCanProposeUNResolutions =
        GetBoolSetting(
            settings,
            "AICanProposeUNResolutions",
            true
        );

    local publicEnemyEnabled =
        GetBoolSetting(
            settings,
            "PublicEnemyEnabled",
            true
        );

    local unLeadershipEnabled =
        GetBoolSetting(
            settings,
            "UNLeadershipEnabled",
            true
        );


    -- =====================================================
    -- SMART AI SETTINGS
    -- =====================================================

    local smartEconomicAIEnabled =
        GetBoolSetting(
            settings,
            "SmartEconomicAIEnabled",
            true
        );

    local aiBaseReservePercent =
        GetNumberSetting(
            settings,
            "AIBaseReservePercent",
            40
        );

    local aiEconomicAggressiveness =
        GetNumberSetting(
            settings,
            "AIEconomicAggressiveness",
            50
        );

    local aiWarAggressiveness =
        GetNumberSetting(
            settings,
            "AIWarAggressiveness",
            35
        );

    local aiStockParticipationEnabled =
        GetBoolSetting(
            settings,
            "AIStockParticipationEnabled",
            true
        );

    local aiETFParticipationEnabled =
        GetBoolSetting(
            settings,
            "AIETFParticipationEnabled",
            true
        );

    local aiBondParticipationEnabled =
        GetBoolSetting(
            settings,
            "AIBondParticipationEnabled",
            true
        );

    local aiTaxManagementEnabled =
        GetBoolSetting(
            settings,
            "AITaxManagementEnabled",
            true
        );

    local playerAIManagerEnabled =
        GetBoolSetting(
            settings,
            "PlayerAIManagerEnabled",
            true
        );


    -- =====================================================
    -- TITLE
    -- =====================================================

    UI.CreateLabel(root)
        .SetText(
            "GLOBAL ECONOMY & DIPLOMACY SETTINGS"
        );

    UI.CreateLabel(root)
        .SetText(
            "Configure diplomacy, trade, investments, markets, taxation, the United Nations, and AI economic behavior."
        );


    -- =====================================================
    -- GENERAL
    -- =====================================================

    AddSection(
        root,
        "GENERAL",
        "Controls the opening period and automatic economic reports."
    );

    AddNumberInput(
        root,
        "OpeningPeriodTurns",
        "Opening Period Before Full Global Economy Activates (turns)",
        openingPeriodTurns,
        0,
        3,
        "Default: 1. Players can establish their nation before all international systems become fully active."
    );

    AddCheckBox(
        root,
        "TurnReportsEnabled",
        "Show consolidated player reports at the beginning of each new turn",
        turnReportsEnabled
    );

    AddCheckBox(
        root,
        "WorldNewsEnabled",
        "Generate Global Economy world-news headlines",
        worldNewsEnabled
    );


    -- =====================================================
    -- DIPLOMACY
    -- =====================================================

    AddSection(
        root,
        "DIPLOMACY",
        "Controls formal Peace and War relationships between nations."
    );

    AddCheckBox(
        root,
        "RequireWarDeclaration",
        "Require an official declaration of war before nations may attack each other",
        requireWarDeclaration
    );

    AddCheckBox(
        root,
        "PlayersStartAtWar",
        "Start all nations at WAR instead of PEACE",
        playersStartAtWar
    );

    AddNumberInput(
        root,
        "WarDeclarationDelay",
        "War Declaration Delay (turns)",
        warDeclarationDelay,
        0,
        3,
        "Default: 1. A declaration can be announced before combat becomes legal."
    );

    AddNumberInput(
        root,
        "PeaceCooldownTurns",
        "Cooldown After Peace Before War Can Be Declared Again",
        peaceCooldownTurns,
        0,
        10,
        "Prevents repeated peace-war-peace abuse."
    );

    AddCheckBox(
        root,
        "NonAggressionPactsEnabled",
        "Enable Non-Aggression Pacts",
        nonAggressionPactsEnabled
    );

    AddCheckBox(
        root,
        "GiftWarRestrictionEnabled",
        "Block wartime Gift Card transfers that bypass official war declarations",
        giftWarRestrictionEnabled
    );

    AddCheckBox(
        root,
        "AICanDeclareWarOnHumans",
        "Allow AI nations to officially declare war on human nations",
        aiCanDeclareWarOnHumans
    );

    AddCheckBox(
        root,
        "AICanDeclareWarOnAI",
        "Allow AI nations to officially declare war on other AI nations",
        aiCanDeclareWarOnAI
    );


    -- =====================================================
    -- TRADE AGREEMENTS
    -- =====================================================

    AddSection(
        root,
        "TRADE AGREEMENTS",
        "Trade provides stable recurring Commerce-based income."
    );

    AddNumberInput(
        root,
        "MaxTradeAgreements",
        "Maximum Active Trade Agreements Per Nation",
        maxTradeAgreements,
        1,
        20,
        "Large games can raise this value. Recommended defaults may later scale automatically with game size."
    );

    AddNumberInput(
        root,
        "TradeBonusPercent",
        "Trade Income Bonus (%)",
        tradeBonusPercent,
        1,
        50,
        "Each nation receives a percentage of its trade partner's Commerce income."
    );

    AddNumberInput(
        root,
        "TradeCooldownTurns",
        "Cooldown After Rejection or Cancellation (turns)",
        tradeCooldownTurns,
        0,
        10,
        ""
    );

    AddNumberInput(
        root,
        "AIProposalChance",
        "Legacy AI Trade Proposal Activity (%)",
        aiProposalChance,
        0,
        100,
        "This setting is preserved while the new Smart AI system is being introduced."
    );

    AddNumberInput(
        root,
        "AIMinimumAgreementTurns",
        "Minimum AI Agreement Duration Before Replacement",
        aiMinimumAgreementTurns,
        0,
        15,
        ""
    );

    AddNumberInput(
        root,
        "AIReplacementPercent",
        "Required Economic Improvement Before AI Replaces Partner (%)",
        aiReplacementPercent,
        10,
        200,
        "Example: 50 means a replacement partner generally needs to be about 50% more attractive."
    );

    AddNumberInput(
        root,
        "EconomicDeclineTurns",
        "Consecutive Declining Income Turns Before AI Becomes Concerned",
        economicDeclineTurns,
        2,
        10,
        "The AI should respond to sustained economic weakness rather than one bad turn."
    );


    -- =====================================================
    -- INVESTMENTS
    -- =====================================================

    AddSection(
        root,
        "INVESTMENTS",
        "Projects provide larger potential returns but lock capital and can fail."
    );

    AddNumberInput(
        root,
        "InvestmentFundingWindow",
        "Project Funding Window (turns)",
        investmentFundingWindow,
        1,
        10,
        "Projects that fail to reach their funding goal before this deadline expire and refund committed principal."
    );

    AddCheckBox(
        root,
        "InternationalInvestorBonusEnabled",
        "Enable an international participation bonus for projects with multiple nations",
        internationalInvestorBonusEnabled
    );

    AddNumberInput(
        root,
        "InvestorSuccessBonusPercent",
        "Success Chance Bonus Per Additional Participating Nation (%)",
        investorSuccessBonusPercent,
        0,
        10,
        "Rewards multinational projects without guaranteeing success."
    );

    AddNumberInput(
        root,
        "MaxInvestorSuccessBonusPercent",
        "Maximum International Participation Success Bonus (%)",
        maxInvestorSuccessBonusPercent,
        0,
        25,
        ""
    );

    AddCheckBox(
        root,
        "AIInvestmentsEnabled",
        "Allow AI nations to invest in projects",
        aiInvestmentsEnabled
    );

    AddCheckBox(
        root,
        "AIProjectsEnabled",
        "Allow AI nations to create investment projects",
        aiProjectsEnabled
    );

    AddNumberInput(
        root,
        "AIProjectChance",
        "Legacy AI Project Creation Activity (%)",
        aiProjectChance,
        0,
        100,
        "Preserved for compatibility while project decisions are moved into Smart AI."
    );

    AddNumberInput(
        root,
        "AIInvestChance",
        "Legacy AI Investment Activity (%)",
        aiInvestChance,
        0,
        100,
        "Preserved for compatibility while investment decisions are moved into Smart AI."
    );

    AddNumberInput(
        root,
        "AIInvestmentReservePercent",
        "Legacy AI Investment Gold Reserve (%)",
        aiInvestmentReservePercent,
        10,
        90,
        "Existing investment code currently uses this value."
    );

    UI.CreateLabel(root)
        .SetText(
            "The seven existing investment categories remain available. Their risk, return, duration, and failure-recovery values will be rebalanced during the investment-engine update."
        );


    -- =====================================================
    -- MARKETS
    -- =====================================================

    AddSection(
        root,
        "MARKETS - STOCKS",
        "Players and AI can create flagship public companies and participate in the global stock market."
    );

    AddCheckBox(
        root,
        "StockMarketEnabled",
        "Enable the Stock Market",
        stockMarketEnabled
    );

    AddNumberInput(
        root,
        "MaxCompaniesPerNation",
        "Maximum Public Companies Per Nation",
        maxCompaniesPerNation,
        1,
        5,
        "Nations begin with access to one flagship company. Additional companies must be unlocked through economic progress."
    );

    AddNumberInput(
        root,
        "FounderSharePercent",
        "Founder Starting Ownership (%)",
        founderSharePercent,
        5,
        50,
        "Founder shares give nations an incentive to strengthen their own economy and company."
    );

    AddNumberInput(
        root,
        "StockVolatilityPercent",
        "Base Stock Market Volatility (%)",
        stockVolatilityPercent,
        1,
        30,
        "Higher values create larger normal stock-price movements."
    );

    AddCheckBox(
        root,
        "DividendsEnabled",
        "Enable stock dividends",
        dividendsEnabled
    );

    AddNumberInput(
        root,
        "DividendFrequencyTurns",
        "Dividend Payment Frequency (turns)",
        dividendFrequencyTurns,
        1,
        10,
        "Growth, Balanced, and Dividend companies will use different dividend behavior."
    );


    -- =====================================================
    -- ETF
    -- =====================================================

    AddSection(
        root,
        "MARKETS - ETF",
        "The global ETF automatically tracks the strongest eligible public companies."
    );

    AddCheckBox(
        root,
        "ETFEnabled",
        "Enable the Global ETF",
        etfEnabled
    );

    AddNumberInput(
        root,
        "ETFSize",
        "Number of Companies in the Global ETF",
        etfSize,
        3,
        10,
        "Default: Top 5. The ETF automatically rebalances when company rankings change."
    );

    AddNumberInput(
        root,
        "ETFMembershipBonusPercent",
        "ETF Membership Market Confidence Bonus (%)",
        etfMembershipBonusPercent,
        0,
        5,
        "Provides a small competitive reward for qualifying without making leading companies unstoppable."
    );

    AddCheckBox(
        root,
        "ETFLoyaltyBonusEnabled",
        "Enable additional prestige for companies that remain in the ETF for consecutive turns",
        etfLoyaltyBonusEnabled
    );


    -- =====================================================
    -- BONDS
    -- =====================================================

    AddSection(
        root,
        "MARKETS - BONDS",
        "Bonds provide more predictable returns but expose investors to credit and default risk."
    );

    AddCheckBox(
        root,
        "BondsEnabled",
        "Enable nation-issued bonds",
        bondsEnabled
    );

    AddNumberInput(
        root,
        "MinimumBondDuration",
        "Minimum Bond Maturity (turns)",
        minimumBondDuration,
        1,
        10,
        ""
    );

    AddNumberInput(
        root,
        "MaximumBondDuration",
        "Maximum Bond Maturity (turns)",
        maximumBondDuration,
        2,
        20,
        "Lower-rated nations may need to offer higher yields to attract investors."
    );


    -- =====================================================
    -- TAXATION
    -- =====================================================

    AddSection(
        root,
        "TAXATION",
        "Taxation converts domestic city-based economic development into government revenue while creating a growth tradeoff."
    );

    AddCheckBox(
        root,
        "TaxationEnabled",
        "Enable domestic taxation",
        taxationEnabled
    );

    AddNumberInput(
        root,
        "TaxChangeCooldownTurns",
        "Tax Policy Change Cooldown (turns)",
        taxChangeCooldownTurns,
        0,
        10,
        "Prevents players from repeatedly changing tax policy to exploit turn timing."
    );

    UI.CreateLabel(root)
        .SetText(
            "Planned policies: Low, Standard, High, and Emergency taxation. Higher taxation provides greater immediate revenue but creates stronger economic and market penalties."
        );


    -- =====================================================
    -- UNITED NATIONS
    -- =====================================================

    AddSection(
        root,
        "UNITED NATIONS",
        "The UN manages international resolutions, sanctions, aid, Public Enemy status, and leadership."
    );

    AddCheckBox(
        root,
        "UnitedNationsEnabled",
        "Enable the United Nations",
        unitedNationsEnabled
    );

    AddNumberInput(
        root,
        "UnitedNationsStartTurn",
        "Turn the United Nations Becomes Active",
        unitedNationsStartTurn,
        1,
        10,
        ""
    );

    AddNumberInput(
        root,
        "UNVoteDurationTurns",
        "UN Voting Duration (turns)",
        unVoteDurationTurns,
        1,
        10,
        ""
    );

    AddNumberInput(
        root,
        "UNPassRequirementPercent",
        "UN Resolution YES Vote Requirement (%)",
        unPassRequirementPercent,
        50,
        100,
        "Default: 60%. Only eligible, non-eliminated nations count toward voting."
    );

    AddNumberInput(
        root,
        "UNProposalCooldownTurns",
        "UN Proposal Cooldown (turns)",
        unProposalCooldownTurns,
        0,
        10,
        ""
    );

    AddNumberInput(
        root,
        "UNMaximumActiveResolutions",
        "Maximum Simultaneous Active UN Resolutions",
        unMaximumActiveResolutions,
        1,
        10,
        ""
    );

    AddCheckBox(
        root,
        "AICanProposeUNResolutions",
        "Allow AI nations to propose UN resolutions",
        aiCanProposeUNResolutions
    );

    AddCheckBox(
        root,
        "PublicEnemyEnabled",
        "Enable Public Enemy designation and consequences",
        publicEnemyEnabled
    );

    AddCheckBox(
        root,
        "UNLeadershipEnabled",
        "Enable UN Chair, Vice Chair, elections, and leadership succession",
        unLeadershipEnabled
    );

    UI.CreateLabel(root)
        .SetText(
            "UN voting will use a simple YES / NO interface with optional reasons, resolution discussion, vote graphs, sanctions, aid, and history."
        );


    -- =====================================================
    -- SMART AI
    -- =====================================================

    AddSection(
        root,
        "SMART AI",
        "AI nations should make connected military, economic, diplomatic, and financial decisions instead of acting through isolated random choices."
    );

    AddCheckBox(
        root,
        "SmartEconomicAIEnabled",
        "Enable Smart Economic & Diplomatic AI",
        smartEconomicAIEnabled
    );

    AddNumberInput(
        root,
        "AIBaseReservePercent",
        "AI Base Treasury Reserve (%)",
        aiBaseReservePercent,
        10,
        90,
        "This becomes a baseline rather than a hard reserve. AI will dynamically raise or lower reserves based on war, threats, obligations, and opportunities."
    );

    AddNumberInput(
        root,
        "AIEconomicAggressiveness",
        "AI Economic Aggressiveness",
        aiEconomicAggressiveness,
        0,
        100,
        "Higher values make AI more willing to pursue economic growth and financial opportunities when financially safe."
    );

    AddNumberInput(
        root,
        "AIWarAggressiveness",
        "AI War Aggressiveness",
        aiWarAggressiveness,
        0,
        100,
        "This affects willingness to consider war. AI should still evaluate military strength, economic cost, current wars, trade relationships, and UN consequences."
    );

    AddCheckBox(
        root,
        "AIStockParticipationEnabled",
        "Allow Smart AI to buy and sell individual stocks",
        aiStockParticipationEnabled
    );

    AddCheckBox(
        root,
        "AIETFParticipationEnabled",
        "Allow Smart AI to invest in the ETF",
        aiETFParticipationEnabled
    );

    AddCheckBox(
        root,
        "AIBondParticipationEnabled",
        "Allow Smart AI to issue and purchase bonds",
        aiBondParticipationEnabled
    );

    AddCheckBox(
        root,
        "AITaxManagementEnabled",
        "Allow Smart AI to dynamically manage taxation",
        aiTaxManagementEnabled
    );


    AddSection(
        root,
        "PLAYER AI MANAGER",
        "Optional automation for human players. It manages stocks and investment projects within a player-set budget, but never controls diplomacy, trade agreements, taxation, ideology, or military orders."
    );

    AddCheckBox(
        root,
        "PlayerAIManagerEnabled",
        "Allow human players to enable the AI Manager",
        playerAIManagerEnabled
    );


    -- =====================================================
    -- PLAYER START / IDEOLOGY INFORMATION
    -- =====================================================

    AddSection(
        root,
        "TURN 1 NATIONAL SETUP",
        "Each active nation will complete a National Setup at the beginning of the game."
    );

    UI.CreateLabel(root)
        .SetText(
            "Planned Turn 1 choices:\n\n" ..
            "- Ideology\n" ..
            "- Economic Strategy\n" ..
            "- Starting Tax Policy\n" ..
            "- Flagship Company Name\n" ..
            "- Company Strategy: Growth / Balanced / Dividend\n" ..
            "- Diplomacy Rules Confirmation\n\n" ..
            "Players are not forced to buy stocks, invest, issue bonds, sign trade agreements, or declare war during Turn 1."
        );


    -- =====================================================
    -- ELIMINATION RULE
    -- =====================================================

    AddSection(
        root,
        "ELIMINATION",
        "Eliminated human and AI nations are automatically removed from the economic and diplomatic systems."
    );

    UI.CreateLabel(root)
        .SetText(
            "Eliminated nations cannot trade, invest, create companies, buy stocks or ETFs, issue or buy bonds, vote in the UN, or use diplomacy. Existing positions will be settled according to each system's elimination rules."
        );


    -- =====================================================
    -- SUMMARY
    -- =====================================================

    AddSection(
        root,
        "DEFAULT GLOBAL ECONOMY",
        "Recommended starting configuration."
    );

    UI.CreateLabel(root)
        .SetText(
            "Opening Period: 1 turn\n" ..
            "War Declaration Required: Yes\n" ..
            "War Declaration Delay: 1 turn\n" ..
            "Maximum Trade Agreements: 3\n" ..
            "Trade Income Bonus: 10%\n" ..
            "Investment Funding Window: 3 turns\n" ..
            "International Investor Bonus: Enabled\n" ..
            "Stock Market: Enabled\n" ..
            "Maximum Companies Per Nation: 3\n" ..
            "Founder Ownership: 20%\n" ..
            "Dividends: Enabled / every 3 turns\n" ..
            "Global ETF: Top 5\n" ..
            "ETF Membership Bonus: 3%\n" ..
            "Bonds: Enabled\n" ..
            "Taxation: Enabled\n" ..
            "United Nations: Enabled\n" ..
            "UN Passage Requirement: 60%\n" ..
            "Public Enemy System: Enabled\n" ..
            "Smart AI: Enabled\n" ..
            "AI Base Reserve: 40%"
        );

    AddDivider(root);

    UI.CreateLabel(root)
        .SetText(
            "This configuration screen establishes the Version 1 foundation. Individual economic formulas and project balance values will be finalized as each server system is rebuilt."
        );

end