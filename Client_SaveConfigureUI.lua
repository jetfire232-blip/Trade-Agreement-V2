-- =========================================================
-- GLOBAL ECONOMY & DIPLOMACY
-- SAVE HOST CONFIGURATION
-- =========================================================


-- =========================================================
-- HELPERS
-- =========================================================

local function ReadNumber(key)

    return math.floor(
        TradeConfigInputs[key]
            .GetValue()
    );
end


local function ReadBool(key)

    return TradeConfigInputs[key]
        .GetIsChecked();
end


local function ValidateRange(
    alert,
    value,
    minimum,
    maximum,
    message
)

    if value < minimum
        or value > maximum then

        alert(message);

        return false;
    end

    return true;
end


-- =========================================================
-- SAVE CONFIGURATION
-- =========================================================

function Client_SaveConfigureUI(
    alert,
    addCard
)

    if TradeConfigInputs == nil then

        alert(
            "Global Economy & Diplomacy configuration UI was not loaded correctly."
        );

        return;
    end


    -- =====================================================
    -- GENERAL
    -- =====================================================

    local openingPeriodTurns =
        ReadNumber(
            "OpeningPeriodTurns"
        );

    local turnReportsEnabled =
        ReadBool(
            "TurnReportsEnabled"
        );

    local worldNewsEnabled =
        ReadBool(
            "WorldNewsEnabled"
        );


    -- =====================================================
    -- DIPLOMACY
    -- =====================================================

    local requireWarDeclaration =
        ReadBool(
            "RequireWarDeclaration"
        );

    local playersStartAtWar =
        ReadBool(
            "PlayersStartAtWar"
        );

    local warDeclarationDelay =
        ReadNumber(
            "WarDeclarationDelay"
        );

    local peaceCooldownTurns =
        ReadNumber(
            "PeaceCooldownTurns"
        );

    local nonAggressionPactsEnabled =
        ReadBool(
            "NonAggressionPactsEnabled"
        );

    local giftWarRestrictionEnabled =
        ReadBool(
            "GiftWarRestrictionEnabled"
        );

    local aiCanDeclareWarOnHumans =
        ReadBool(
            "AICanDeclareWarOnHumans"
        );

    local aiCanDeclareWarOnAI =
        ReadBool(
            "AICanDeclareWarOnAI"
        );


    -- =====================================================
    -- TRADE AGREEMENTS
    -- =====================================================

    local maxTradeAgreements =
        ReadNumber(
            "MaxTradeAgreements"
        );

    local tradeBonusPercent =
        ReadNumber(
            "TradeBonusPercent"
        );

    local tradeCooldownTurns =
        ReadNumber(
            "TradeCooldownTurns"
        );

    local aiProposalChance =
        ReadNumber(
            "AIProposalChance"
        );

    local aiMinimumAgreementTurns =
        ReadNumber(
            "AIMinimumAgreementTurns"
        );

    local aiReplacementPercent =
        ReadNumber(
            "AIReplacementPercent"
        );

    local economicDeclineTurns =
        ReadNumber(
            "EconomicDeclineTurns"
        );


    -- =====================================================
    -- INVESTMENTS
    -- =====================================================

    local investmentFundingWindow =
        ReadNumber(
            "InvestmentFundingWindow"
        );

    local internationalInvestorBonusEnabled =
        ReadBool(
            "InternationalInvestorBonusEnabled"
        );

    local investorSuccessBonusPercent =
        ReadNumber(
            "InvestorSuccessBonusPercent"
        );

    local maxInvestorSuccessBonusPercent =
        ReadNumber(
            "MaxInvestorSuccessBonusPercent"
        );

    local aiInvestmentsEnabled =
        ReadBool(
            "AIInvestmentsEnabled"
        );

    local aiProjectsEnabled =
        ReadBool(
            "AIProjectsEnabled"
        );

    local aiProjectChance =
        ReadNumber(
            "AIProjectChance"
        );

    local aiInvestChance =
        ReadNumber(
            "AIInvestChance"
        );

    local aiInvestmentReservePercent =
        ReadNumber(
            "AIInvestmentReservePercent"
        );


    -- =====================================================
    -- STOCK MARKET
    -- =====================================================

    local stockMarketEnabled =
        ReadBool(
            "StockMarketEnabled"
        );

    local maxCompaniesPerNation =
        ReadNumber(
            "MaxCompaniesPerNation"
        );

    local founderSharePercent =
        ReadNumber(
            "FounderSharePercent"
        );

    local stockVolatilityPercent =
        ReadNumber(
            "StockVolatilityPercent"
        );

    local dividendsEnabled =
        ReadBool(
            "DividendsEnabled"
        );

    local dividendFrequencyTurns =
        ReadNumber(
            "DividendFrequencyTurns"
        );


    -- =====================================================
    -- ETF
    -- =====================================================

    local etfEnabled =
        ReadBool(
            "ETFEnabled"
        );

    local etfSize =
        ReadNumber(
            "ETFSize"
        );

    local etfMembershipBonusPercent =
        ReadNumber(
            "ETFMembershipBonusPercent"
        );

    local etfLoyaltyBonusEnabled =
        ReadBool(
            "ETFLoyaltyBonusEnabled"
        );


    -- =====================================================
    -- BONDS
    -- =====================================================

    local bondsEnabled =
        ReadBool(
            "BondsEnabled"
        );

    local minimumBondDuration =
        ReadNumber(
            "MinimumBondDuration"
        );

    local maximumBondDuration =
        ReadNumber(
            "MaximumBondDuration"
        );


    -- =====================================================
    -- TAXATION
    -- =====================================================

    local taxationEnabled =
        ReadBool(
            "TaxationEnabled"
        );

    local taxChangeCooldownTurns =
        ReadNumber(
            "TaxChangeCooldownTurns"
        );


    -- =====================================================
    -- UNITED NATIONS
    -- =====================================================

    local unitedNationsEnabled =
        ReadBool(
            "UnitedNationsEnabled"
        );

    local unitedNationsStartTurn =
        ReadNumber(
            "UnitedNationsStartTurn"
        );

    local unVoteDurationTurns =
        ReadNumber(
            "UNVoteDurationTurns"
        );

    local unPassRequirementPercent =
        ReadNumber(
            "UNPassRequirementPercent"
        );

    local unProposalCooldownTurns =
        ReadNumber(
            "UNProposalCooldownTurns"
        );

    local unMaximumActiveResolutions =
        ReadNumber(
            "UNMaximumActiveResolutions"
        );

    local aiCanProposeUNResolutions =
        ReadBool(
            "AICanProposeUNResolutions"
        );

    local publicEnemyEnabled =
        ReadBool(
            "PublicEnemyEnabled"
        );

    local unLeadershipEnabled =
        ReadBool(
            "UNLeadershipEnabled"
        );


    -- =====================================================
    -- RESOURCES
    -- =====================================================

    local resourcesEnabled =
        ReadBool(
            "ResourcesEnabled"
        );

    local randomizedResourcePlacement =
        ReadBool(
            "RandomizedResourcePlacement"
        );

    local advancedResourcesEnabled =
        ReadBool(
            "AdvancedResourcesEnabled"
        );

    local resourceTradingEnabled =
        ReadBool(
            "ResourceTradingEnabled"
        );

    local resourceFacilityBaseCost =
        ReadNumber(
            "ResourceFacilityBaseCost"
        );

    local resourceFacilityMaxLevel =
        ReadNumber(
            "ResourceFacilityMaxLevel"
        );

    local resourceShortagePenaltyPercent =
        ReadNumber(
            "ResourceShortagePenaltyPercent"
        );

    local resourceUnrestEnabled =
        ReadBool(
            "ResourceUnrestEnabled"
        );


    -- =====================================================
    -- SMART AI
    -- =====================================================

    local smartEconomicAIEnabled =
        ReadBool(
            "SmartEconomicAIEnabled"
        );

    local aiBaseReservePercent =
        ReadNumber(
            "AIBaseReservePercent"
        );

    local aiEconomicAggressiveness =
        ReadNumber(
            "AIEconomicAggressiveness"
        );

    local aiWarAggressiveness =
        ReadNumber(
            "AIWarAggressiveness"
        );

    local aiStockParticipationEnabled =
        ReadBool(
            "AIStockParticipationEnabled"
        );

    local aiETFParticipationEnabled =
        ReadBool(
            "AIETFParticipationEnabled"
        );

    local aiBondParticipationEnabled =
        ReadBool(
            "AIBondParticipationEnabled"
        );

    local aiTaxManagementEnabled =
        ReadBool(
            "AITaxManagementEnabled"
        );

    local playerAIManagerEnabled =
        ReadBool(
            "PlayerAIManagerEnabled"
        );


    -- =====================================================
    -- VALIDATE GENERAL
    -- =====================================================

    if not ValidateRange(
        alert,
        openingPeriodTurns,
        0,
        3,
        "Opening Period must be between 0 and 3 turns."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE DIPLOMACY
    -- =====================================================

    if not ValidateRange(
        alert,
        warDeclarationDelay,
        0,
        3,
        "War Declaration Delay must be between 0 and 3 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        peaceCooldownTurns,
        0,
        10,
        "Peace Cooldown must be between 0 and 10 turns."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE TRADE
    -- =====================================================

    if not ValidateRange(
        alert,
        maxTradeAgreements,
        1,
        20,
        "Maximum Trade Agreements must be between 1 and 20."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        tradeBonusPercent,
        1,
        50,
        "Trade Income Bonus must be between 1% and 50%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        tradeCooldownTurns,
        0,
        10,
        "Trade Cooldown must be between 0 and 10 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiProposalChance,
        0,
        100,
        "AI Proposal Chance must be between 0% and 100%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiMinimumAgreementTurns,
        0,
        15,
        "Minimum AI Agreement Duration must be between 0 and 15 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiReplacementPercent,
        10,
        200,
        "AI Replacement Improvement must be between 10% and 200%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        economicDeclineTurns,
        2,
        10,
        "Economic Decline Sensitivity must be between 2 and 10 turns."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE INVESTMENTS
    -- =====================================================

    if not ValidateRange(
        alert,
        investmentFundingWindow,
        1,
        10,
        "Investment Funding Window must be between 1 and 10 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        investorSuccessBonusPercent,
        0,
        10,
        "Investor Success Bonus must be between 0% and 10%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        maxInvestorSuccessBonusPercent,
        0,
        25,
        "Maximum Investor Success Bonus must be between 0% and 25%."
    ) then
        return;
    end


    if investorSuccessBonusPercent >
        maxInvestorSuccessBonusPercent
        and maxInvestorSuccessBonusPercent > 0 then

        alert(
            "The success bonus per additional investor cannot be greater than the maximum international participation bonus."
        );

        return;
    end


    if not ValidateRange(
        alert,
        aiProjectChance,
        0,
        100,
        "AI Project Creation Chance must be between 0% and 100%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiInvestChance,
        0,
        100,
        "AI Investment Chance must be between 0% and 100%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiInvestmentReservePercent,
        10,
        90,
        "Legacy AI Investment Reserve must be between 10% and 90%."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE STOCKS
    -- =====================================================

    if not ValidateRange(
        alert,
        maxCompaniesPerNation,
        1,
        5,
        "Maximum Companies Per Nation must be between 1 and 5."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        founderSharePercent,
        5,
        50,
        "Founder Starting Ownership must be between 5% and 50%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        stockVolatilityPercent,
        1,
        30,
        "Stock Market Volatility must be between 1% and 30%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        dividendFrequencyTurns,
        1,
        10,
        "Dividend Frequency must be between 1 and 10 turns."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE ETF
    -- =====================================================

    if not ValidateRange(
        alert,
        etfSize,
        3,
        10,
        "ETF Size must be between 3 and 10 companies."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        etfMembershipBonusPercent,
        0,
        5,
        "ETF Membership Bonus must be between 0% and 5%."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE BONDS
    -- =====================================================

    if not ValidateRange(
        alert,
        minimumBondDuration,
        1,
        10,
        "Minimum Bond Duration must be between 1 and 10 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        maximumBondDuration,
        2,
        20,
        "Maximum Bond Duration must be between 2 and 20 turns."
    ) then
        return;
    end


    if minimumBondDuration >
        maximumBondDuration then

        alert(
            "Minimum Bond Duration cannot be greater than Maximum Bond Duration."
        );

        return;
    end


    -- =====================================================
    -- VALIDATE TAXATION
    -- =====================================================

    if not ValidateRange(
        alert,
        taxChangeCooldownTurns,
        0,
        10,
        "Tax Policy Change Cooldown must be between 0 and 10 turns."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE UNITED NATIONS
    -- =====================================================

    if not ValidateRange(
        alert,
        unitedNationsStartTurn,
        1,
        10,
        "United Nations Start Turn must be between Turn 1 and Turn 10."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        unVoteDurationTurns,
        1,
        10,
        "UN Voting Duration must be between 1 and 10 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        unPassRequirementPercent,
        50,
        100,
        "UN Passage Requirement must be between 50% and 100%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        unProposalCooldownTurns,
        0,
        10,
        "UN Proposal Cooldown must be between 0 and 10 turns."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        unMaximumActiveResolutions,
        1,
        10,
        "Maximum Active UN Resolutions must be between 1 and 10."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE RESOURCES
    -- =====================================================

    if not ValidateRange(
        alert,
        resourceFacilityBaseCost,
        25,
        1000,
        "Resource Facility Base Cost must be between 25 and 1000 gold."
    ) then
        return;
    end

    if not ValidateRange(
        alert,
        resourceFacilityMaxLevel,
        1,
        5,
        "Maximum Resource Facility Level must be between 1 and 5."
    ) then
        return;
    end

    if not ValidateRange(
        alert,
        resourceShortagePenaltyPercent,
        0,
        10,
        "Resource Shortage Penalty must be between 0% and 10% per essential shortage."
    ) then
        return;
    end


    -- =====================================================
    -- VALIDATE SMART AI
    -- =====================================================

    if not ValidateRange(
        alert,
        aiBaseReservePercent,
        10,
        90,
        "AI Base Treasury Reserve must be between 10% and 90%."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiEconomicAggressiveness,
        0,
        100,
        "AI Economic Aggressiveness must be between 0 and 100."
    ) then
        return;
    end


    if not ValidateRange(
        alert,
        aiWarAggressiveness,
        0,
        100,
        "AI War Aggressiveness must be between 0 and 100."
    ) then
        return;
    end


    -- =====================================================
    -- SAVE GENERAL
    -- =====================================================

    Mod.Settings.OpeningPeriodTurns =
        openingPeriodTurns;

    Mod.Settings.TurnReportsEnabled =
        turnReportsEnabled;

    Mod.Settings.WorldNewsEnabled =
        worldNewsEnabled;


    -- =====================================================
    -- SAVE DIPLOMACY
    -- =====================================================

    Mod.Settings.RequireWarDeclaration =
        requireWarDeclaration;

    Mod.Settings.PlayersStartAtWar =
        playersStartAtWar;

    Mod.Settings.WarDeclarationDelay =
        warDeclarationDelay;

    Mod.Settings.PeaceCooldownTurns =
        peaceCooldownTurns;

    Mod.Settings.NonAggressionPactsEnabled =
        nonAggressionPactsEnabled;

    Mod.Settings.GiftWarRestrictionEnabled =
        giftWarRestrictionEnabled;

    Mod.Settings.AICanDeclareWarOnHumans =
        aiCanDeclareWarOnHumans;

    Mod.Settings.AICanDeclareWarOnAI =
        aiCanDeclareWarOnAI;


    -- =====================================================
    -- SAVE TRADE
    -- =====================================================

    Mod.Settings.MaxTradeAgreements =
        maxTradeAgreements;

    Mod.Settings.TradeBonusPercent =
        tradeBonusPercent;

    Mod.Settings.TradeCooldownTurns =
        tradeCooldownTurns;

    Mod.Settings.AIProposalChance =
        aiProposalChance;

    Mod.Settings.AIMinimumAgreementTurns =
        aiMinimumAgreementTurns;

    Mod.Settings.AIReplacementPercent =
        aiReplacementPercent;

    Mod.Settings.EconomicDeclineTurns =
        economicDeclineTurns;


    -- =====================================================
    -- SAVE INVESTMENTS
    -- =====================================================

    Mod.Settings.InvestmentFundingWindow =
        investmentFundingWindow;

    Mod.Settings.InternationalInvestorBonusEnabled =
        internationalInvestorBonusEnabled;

    Mod.Settings.InvestorSuccessBonusPercent =
        investorSuccessBonusPercent;

    Mod.Settings.MaxInvestorSuccessBonusPercent =
        maxInvestorSuccessBonusPercent;

    Mod.Settings.AIInvestmentsEnabled =
        aiInvestmentsEnabled;

    Mod.Settings.AIProjectsEnabled =
        aiProjectsEnabled;

    Mod.Settings.AIProjectChance =
        aiProjectChance;

    Mod.Settings.AIInvestChance =
        aiInvestChance;

    Mod.Settings.AIInvestmentReservePercent =
        aiInvestmentReservePercent;


    -- =====================================================
    -- SAVE STOCKS
    -- =====================================================

    Mod.Settings.StockMarketEnabled =
        stockMarketEnabled;

    Mod.Settings.MaxCompaniesPerNation =
        maxCompaniesPerNation;

    Mod.Settings.FounderSharePercent =
        founderSharePercent;

    Mod.Settings.StockVolatilityPercent =
        stockVolatilityPercent;

    Mod.Settings.DividendsEnabled =
        dividendsEnabled;

    Mod.Settings.DividendFrequencyTurns =
        dividendFrequencyTurns;


    -- =====================================================
    -- SAVE ETF
    -- =====================================================

    Mod.Settings.ETFEnabled =
        etfEnabled;

    Mod.Settings.ETFSize =
        etfSize;

    Mod.Settings.ETFMembershipBonusPercent =
        etfMembershipBonusPercent;

    Mod.Settings.ETFLoyaltyBonusEnabled =
        etfLoyaltyBonusEnabled;


    -- =====================================================
    -- SAVE BONDS
    -- =====================================================

    Mod.Settings.BondsEnabled =
        bondsEnabled;

    Mod.Settings.MinimumBondDuration =
        minimumBondDuration;

    Mod.Settings.MaximumBondDuration =
        maximumBondDuration;


    -- =====================================================
    -- SAVE TAXATION
    -- =====================================================

    Mod.Settings.TaxationEnabled =
        taxationEnabled;

    Mod.Settings.TaxChangeCooldownTurns =
        taxChangeCooldownTurns;


    -- =====================================================
    -- SAVE UNITED NATIONS
    -- =====================================================

    Mod.Settings.UnitedNationsEnabled =
        unitedNationsEnabled;

    Mod.Settings.UnitedNationsStartTurn =
        unitedNationsStartTurn;

    Mod.Settings.UNVoteDurationTurns =
        unVoteDurationTurns;

    Mod.Settings.UNPassRequirementPercent =
        unPassRequirementPercent;

    Mod.Settings.UNProposalCooldownTurns =
        unProposalCooldownTurns;

    Mod.Settings.UNMaximumActiveResolutions =
        unMaximumActiveResolutions;

    Mod.Settings.AICanProposeUNResolutions =
        aiCanProposeUNResolutions;

    Mod.Settings.PublicEnemyEnabled =
        publicEnemyEnabled;

    Mod.Settings.UNLeadershipEnabled =
        unLeadershipEnabled;


    -- =====================================================
    -- SAVE RESOURCES
    -- =====================================================

    Mod.Settings.ResourcesEnabled =
        resourcesEnabled;

    Mod.Settings.RandomizedResourcePlacement =
        randomizedResourcePlacement;

    Mod.Settings.AdvancedResourcesEnabled =
        advancedResourcesEnabled;

    Mod.Settings.ResourceTradingEnabled =
        resourceTradingEnabled;

    Mod.Settings.ResourceFacilityBaseCost =
        resourceFacilityBaseCost;

    Mod.Settings.ResourceFacilityMaxLevel =
        resourceFacilityMaxLevel;

    Mod.Settings.ResourceShortagePenaltyPercent =
        resourceShortagePenaltyPercent;

    Mod.Settings.ResourceUnrestEnabled =
        resourceUnrestEnabled;


    -- =====================================================
    -- SAVE SMART AI
    -- =====================================================

    Mod.Settings.SmartEconomicAIEnabled =
        smartEconomicAIEnabled;

    Mod.Settings.AIBaseReservePercent =
        aiBaseReservePercent;

    Mod.Settings.AIEconomicAggressiveness =
        aiEconomicAggressiveness;

    Mod.Settings.AIWarAggressiveness =
        aiWarAggressiveness;

    Mod.Settings.AIStockParticipationEnabled =
        aiStockParticipationEnabled;

    Mod.Settings.AIETFParticipationEnabled =
        aiETFParticipationEnabled;

    Mod.Settings.AIBondParticipationEnabled =
        aiBondParticipationEnabled;

    Mod.Settings.AITaxManagementEnabled =
        aiTaxManagementEnabled;

    Mod.Settings.PlayerAIManagerEnabled =
        playerAIManagerEnabled;


    -- =====================================================
    -- VERSION
    -- =====================================================

    Mod.Settings.EconomyModVersion =
        3;

end