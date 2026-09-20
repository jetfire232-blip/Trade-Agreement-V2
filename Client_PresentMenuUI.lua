ContentArea = nil;
local MAX_VISIBLE_HISTORY = 40;

InvestmentProjectTypes = {
    {
        id = "port",
        name = "Port Expansion",
        maxGoal = 1200,
        duration = 3,
        successReturn = 15,
        failureRecovery = 90,
        successChance = 90,
        risk = "Low"
    },
    {
        id = "commercial",
        name = "Commercial District",
        maxGoal = 1500,
        duration = 4,
        successReturn = 22,
        failureRecovery = 80,
        successChance = 82,
        risk = "Low-Medium"
    },
    {
        id = "infrastructure",
        name = "Infrastructure Corridor",
        maxGoal = 1800,
        duration = 5,
        successReturn = 28,
        failureRecovery = 80,
        successChance = 78,
        risk = "Medium"
    },
    {
        id = "industrial",
        name = "Industrial Development",
        maxGoal = 2000,
        duration = 5,
        successReturn = 35,
        failureRecovery = 70,
        successChance = 72,
        risk = "Medium"
    },
    {
        id = "resource",
        name = "Resource Development",
        maxGoal = 2400,
        duration = 4,
        successReturn = 45,
        failureRecovery = 55,
        successChance = 65,
        risk = "Medium-High"
    },
    {
        id = "technology",
        name = "Technology Venture",
        maxGoal = 3000,
        duration = 6,
        successReturn = 70,
        failureRecovery = 35,
        successChance = 55,
        risk = "High"
    },
    {
        id = "space",
        name = "Space Exploration",
        maxGoal = 4000,
        duration = 8,
        successReturn = 100,
        failureRecovery = 20,
        successChance = 45,
        risk = "Very High"
    },

    {
        id = "agriculture",
        name = "Agricultural Development",
        maxGoal = 1400,
        duration = 3,
        successReturn = 18,
        failureRecovery = 85,
        successChance = 86,
        risk = "Low"
    },

    {
        id = "energy",
        name = "Energy Development",
        maxGoal = 2200,
        duration = 4,
        successReturn = 38,
        failureRecovery = 65,
        successChance = 70,
        risk = "Medium"
    },

    {
        id = "defense",
        name = "Defense Industry Expansion",
        maxGoal = 2600,
        duration = 5,
        successReturn = 48,
        failureRecovery = 55,
        successChance = 64,
        risk = "Medium-High"
    },

    {
        id = "finance",
        name = "Financial Center",
        maxGoal = 2800,
        duration = 5,
        successReturn = 55,
        failureRecovery = 50,
        successChance = 60,
        risk = "High"
    },

    {
        id = "logistics",
        name = "Logistics & Supply Network",
        maxGoal = 1900,
        duration = 4,
        successReturn = 30,
        failureRecovery = 75,
        successChance = 76,
        risk = "Medium"
    }
};

function GetClientSetting(name, defaultValue)

    local settings =
        Mod.Settings or {};

    if settings[name] == nil then
        return defaultValue;
    end

    return settings[name];
end

function ClientMaxAgreements()

    return GetClientSetting(
        "MaxTradeAgreements",
        3
    );
end

function ClientTradeBonusPercent()

    return GetClientSetting(
        "TradeBonusPercent",
        10
    );
end

function ClientTradeCooldownTurns()

    return GetClientSetting(
        "TradeCooldownTurns",
        3
    );
end


PlayerTabVisibility = PlayerTabVisibility or {
    investments = true,
    markets = true,
    taxation = true,
    globalEconomy = true,
    howItWorks = true
};

ActiveMainTab = ActiveMainTab or "overview";
MainTabsArea = nil;


function MainTabText(key, label)

    if ActiveMainTab == key then
        return "▶ " .. label;
    end

    return label;
end

function GetPlayerUIColor(
    game,
    playerID,
    fallback
)

    local defaultColor =
        fallback
        or "#FFFFFF";

    if game == nil
        or game.Game == nil
        or game.Game.Players == nil
    then
        return defaultColor;
    end

    local player =
        game.Game.Players[
            playerID
        ];

    if player == nil
        or player.Color == nil
        or player.Color.HtmlColor == nil
    then
        return defaultColor;
    end

    local color =
        tostring(
            player.Color.HtmlColor
        );

    if color == "" then
        return defaultColor;
    end

    if string.sub(color, 1, 1) ~= "#" then
        color = "#" .. color;
    end

    return color;
end


function ShowComingSoonSection(
    parent,
    title,
    description
)

    local area =
        CreateContentArea(parent);

    UI.CreateLabel(area)
        .SetText(title);

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    UI.CreateLabel(area)
        .SetText(description);

    UI.CreateLabel(area)
        .SetText(
            "\nThis section is now part of the new Global Economy interface. Its gameplay engine will be connected during the next build stages."
        );
end


function ShowDiplomacyMenu(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData
        or {};


    local economy =
        data.globalEconomy
        or {};


    local diplomacy =
        economy.diplomacy
        or {};

    local playerSearchInput =
    nil;

local playerSearchResults =
    nil;

local playerSearchResultsHost =
    nil;

    local selectedDiplomacyPlayerID =
    nil;

local selectedDiplomacyPlayerName =
    nil;

    local selectedDiplomacyPlayerLabel =
    nil;

    local selectedDiplomacyOverviewGroup =
    nil;

    local selectedDiplomacyOverviewHost =
    nil;

    local relationships =
        diplomacy.relationships
        or {};


    local pendingWarDeclarations =
        diplomacy.pendingWarDeclarations
        or {};


    local pendingPeaceOffers =
        diplomacy.pendingPeaceOffers
        or {};


    local pendingNAPOffers =
        diplomacy.pendingNAPOffers
        or {};
    
    local pendingAllianceOffers =
    diplomacy.pendingAllianceOffers
    or {};

    local alliances =
    diplomacy.alliances
    or {};

local factions =
    diplomacy.factions
    or {};

local pendingFactionInvites =
    diplomacy.pendingFactionInvites
    or {};

local playerFaction =
    diplomacy.playerFaction
    or {};

    local nonAggressionPacts =
        diplomacy.nonAggressionPacts
        or {};


    local history =
        diplomacy.history
        or {};


    local ourID =
        game.Us.ID;

local ourFactionID =
    playerFaction[
        ourID
    ];

local ourFaction =
    nil;

if ourFactionID ~= nil then

    ourFaction =
        factions[
            ourFactionID
        ];

end


local function RefreshSelectedDiplomacyOverview()

    if selectedDiplomacyOverviewHost == nil then

        return;

    end

if selectedDiplomacyOverviewGroup ~= nil
    and not UI.IsDestroyed(
        selectedDiplomacyOverviewGroup
    )
then

    UI.Destroy(
        selectedDiplomacyOverviewGroup
    );

end

selectedDiplomacyOverviewGroup =
    UI.CreateVerticalLayoutGroup(
        selectedDiplomacyOverviewHost
    );

    if selectedDiplomacyPlayerID == nil then

        UI.CreateLabel(
            selectedDiplomacyOverviewGroup
        )
            .SetText(
                "Select a player to view their overview."
            );

        return;
    end


    local targetID =
        selectedDiplomacyPlayerID;

    local targetName =
        selectedDiplomacyPlayerName
        or GetPlayerName(
            game,
            targetID
        );


    local a =
        tostring(
            ourID
        );

    local b =
        tostring(
            targetID
        );

    local key;

    if a < b then

        key =
            a ..
            "|" ..
            b;

    else

        key =
            b ..
            "|" ..
            a;

    end


    local relationship =
        relationships[
            key
        ];

    local status =
        "peace";

    if relationship ~= nil
        and relationship.status ~= nil then

        status =
            relationship.status;

    end


    local activeNAP =
        nonAggressionPacts[
            key
        ];

    local activeAlliance =
        alliances[
            key
        ];

    local hasNAP =
        activeNAP ~= nil
        and activeNAP.active == true;

    local isAllied =
        activeAlliance ~= nil
        and activeAlliance.active == true;


    local targetNation =
        (
            economy.nations
            and economy.nations[
                targetID
            ]
        )
        or {};


    local targetColor =
        GetPlayerUIColor(
            game,
            targetID,
            "#FFFFFF"
        );

    local overviewTitle =
        UI.CreateLabel(
            selectedDiplomacyOverviewGroup
        )
            .SetText(
                "PLAYER OVERVIEW - " ..
                tostring(targetName)
            );

    overviewTitle.SetColor(
        targetColor
    );

    local function AddOverviewPair(
        leftText,
        rightText
    )

        local row =
            UI.CreateHorizontalLayoutGroup(
                selectedDiplomacyOverviewGroup
            );

        UI.CreateLabel(row)
            .SetText(leftText)
            .SetFlexibleWidth(1);

        UI.CreateLabel(row)
            .SetText(rightText)
            .SetFlexibleWidth(1);

    end

    AddOverviewPair(
        "Relationship: " ..
        string.upper(
            tostring(status)
        ),
        "Commerce/Turn: " ..
        tostring(
            GetPlayerIncome(
                game,
                targetID
            )
        )
    );

    AddOverviewPair(
        "Ideology: " ..
        tostring(
            targetNation.ideology
            or "Unknown"
        ),
        "Tax Policy: " ..
        tostring(
            targetNation.taxPolicy
            or "Unknown"
        )
    );

    AddOverviewPair(
        "Economic Strategy: " ..
        tostring(
            targetNation.economicStrategy
            or "Unknown"
        ),
        "Company Strategy: " ..
        tostring(
            targetNation.companyStrategy
            or "Unknown"
        )
    );

    AddOverviewPair(
        "NAP: " ..
        (
            hasNAP
            and "ACTIVE"
            or "NONE"
        ),
        "Alliance: " ..
        (
            isAllied
            and "ACTIVE"
            or "NONE"
        )
    );

    UI.CreateLabel(
        selectedDiplomacyOverviewGroup
    )
        .SetText(
            "Flagship Company: " ..
            tostring(
                targetNation.flagshipCompanyName
                or "None"
            )
        );

UI.CreateLabel(
    selectedDiplomacyOverviewGroup
)
    .SetText(
        "\nRECENT DIPLOMACY HISTORY"
    );

local matchingEvents =
    {};

for i =
    #history,
    1,
    -1 do

    local event =
        history[
            i
        ];

    if event ~= nil
        and (
            event.player1 == targetID
            or event.player2 == targetID
        )
    then

        table.insert(
            matchingEvents,
            event
        );

        if #matchingEvents >= 10 then
            break;
        end

    end

end

if #matchingEvents == 0 then

    UI.CreateLabel(
        selectedDiplomacyOverviewGroup
    )
        .SetText(
            "No diplomacy history with this player yet."
        );

else

    for _, event
        in ipairs(
            matchingEvents
        ) do

        UI.CreateLabel(
            selectedDiplomacyOverviewGroup
        )
            .SetText(
                "Turn " ..
                tostring(
                    event.turn
                    or "?"
                ) ..
                " - " ..
                tostring(
                    event.message
                    or event.type
                    or "Diplomacy event"
                )
            );

    end

end

end

local function RefreshPlayerSearchResults()

    if playerSearchResultsHost == nil
        or playerSearchInput == nil
    then
        return;
    end

    if playerSearchResults ~= nil
        and not UI.IsDestroyed(
            playerSearchResults
        )
    then

        UI.Destroy(
            playerSearchResults
        );

    end

    playerSearchResults =
        UI.CreateVerticalLayoutGroup(
            playerSearchResultsHost
        );

    local searchText =
        string.lower(
            playerSearchInput.GetText()
            or ""
        );

    local matches =
        {};

    for playerID, player
        in pairs(
            game.Game.Players
            or {}
        )
    do

        if playerID ~= ourID
            and player.State == WL.GamePlayerState.Playing
        then

            local playerName =
                player.DisplayName(
                    nil,
                    false
                );

            local lowerName =
                string.lower(
                    playerName
                    or ""
                );

            if searchText == ""
                or string.find(
                    lowerName,
                    searchText,
                    1,
                    true
                ) ~= nil
            then

                table.insert(
                    matches,
                    {
                        id = playerID,
                        name = playerName
                    }
                );

            end

        end

    end

    table.sort(
        matches,
        function(a, b)

            return string.lower(
                tostring(a.name)
            ) < string.lower(
                tostring(b.name)
            );

        end
    );

    if #matches == 0 then

        UI.CreateLabel(
            playerSearchResults
        )
            .SetText(
                "No players match your search."
            );

        return;
    end

    local row = nil;

    for index, entry
        in ipairs(matches)
    do

        if (index - 1) % 3 == 0 then

            row =
                UI.CreateHorizontalLayoutGroup(
                    playerSearchResults
                );

        end

        local targetID =
            entry.id;

        local targetName =
            entry.name;

        local playerButton =
            UI.CreateButton(row)
                .SetText(
                    tostring(targetName)
                )
                .SetFlexibleWidth(1)
                .SetPreferredHeight(36)
                .SetTextColor(
                    GetPlayerUIColor(
                        game,
                        targetID,
                        "#FFFFFF"
                    )
                );

        if selectedDiplomacyPlayerID == targetID then

            playerButton.SetColor(
                "#606060"
            );

        else

            playerButton.SetColor(
                "#BABABC"
            );

        end

        playerButton.SetOnClick(function()

            selectedDiplomacyPlayerID =
                targetID;

            selectedDiplomacyPlayerName =
                targetName;

            if selectedDiplomacyPlayerLabel ~= nil then

                selectedDiplomacyPlayerLabel.SetText(
                    "Selected Player: " ..
                    tostring(
                        selectedDiplomacyPlayerName
                    )
                );

                selectedDiplomacyPlayerLabel.SetColor(
                    GetPlayerUIColor(
                        game,
                        targetID,
                        "#FFFFFF"
                    )
                );

            end

            RefreshSelectedDiplomacyOverview();
            RefreshPlayerSearchResults();

        end);

    end

end

    UI.CreateLabel(area)
        .SetText(
            "DIPLOMACY"
        );

    UI.CreateLabel(area)
        .SetText(
            "Search or tap a player to open their overview."
        );

    playerSearchInput =
        UI.CreateTextInputField(
            area
        )
            .SetPlaceholderText(
                "Search players..."
            )
            .SetOnValueChanged(function()

                RefreshPlayerSearchResults();

            end);

    playerSearchResultsHost =
        UI.CreateVerticalLayoutGroup(
            area
        );

    playerSearchResults =
        UI.CreateVerticalLayoutGroup(
            playerSearchResultsHost
        );

    selectedDiplomacyPlayerLabel =
        UI.CreateLabel(area)
            .SetText(
                "Selected Player: None"
            );

    selectedDiplomacyOverviewHost =
        UI.CreateVerticalLayoutGroup(
            area
        );

    selectedDiplomacyOverviewGroup =
        UI.CreateVerticalLayoutGroup(
            selectedDiplomacyOverviewHost
        );

    RefreshPlayerSearchResults();
    RefreshSelectedDiplomacyOverview();

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "Official Peace / War relationships control when nations may attack each other."
        );


    -- =====================================================
    -- RELATIONS
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "\nRELATIONS"
        );


    local foundRelation =
        false;


    for playerID, player
        in pairs(
            game.Game.Players
        ) do


        if playerID
            ~= ourID
            and player.State
            == WL.GamePlayerState.Playing then


            foundRelation =
                true;


local otherName =
    GetPlayerName(
        game,
        playerID
    );

local targetID =
    playerID;

local a =
    tostring(
        ourID
    ); 

            local a =
                tostring(
                    ourID
                );


            local b =
                tostring(
                    playerID
                );


            local key;


            if a < b then

                key =
                    a ..
                    "|" ..
                    b;

            else

                key =
                    b ..
                    "|" ..
                    a;

            end


            local relationship =
                relationships[
                    key
                ];


            local status =
                "peace";


            if relationship ~= nil
                and relationship.status
                ~= nil then


                status =
                    relationship.status;
            end


            local activeNAP =
                nonAggressionPacts[
                    key
                ];
            
            local activeAlliance =
    alliances[
        key
    ];

            local isAllied =
    activeAlliance ~= nil
    and activeAlliance.active == true;

            local row =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            local statusText =
                otherName ..
                " | " ..
                string.upper(
                    status
                );
if isAllied then

    statusText =
        statusText ..
        " | ALLIED";

end

            if activeNAP ~= nil
                and activeNAP.active
                == true then


                local currentTurn =
                    economy.currentEconomyTurn
                    or data.tradeTurn
                    or 1;


                if currentTurn
                    < (
                        activeNAP.endTurn
                        or currentTurn
                    ) then


                    statusText =
                        statusText ..
                        " | NAP until Turn " ..
                        tostring(
                            activeNAP.endTurn
                        );
                end
            end


            local pendingWar =
                pendingWarDeclarations[
                    key
                ];


            if pendingWar ~= nil then


                statusText =
                    statusText ..
                    " | WAR DECLARED - activates Turn " ..
                    tostring(
                        pendingWar.activatesTurn
                        or "?"
                    );
            end


            local relationLabel =
                UI.CreateLabel(row)
                    .SetText(
                        statusText
                    );

            relationLabel.SetColor(
                GetPlayerUIColor(
                    game,
                    playerID,
                    "#FFFFFF"
                )
            );


            -- =================================================
            -- PEACE ACTIONS
            -- =================================================

            if status
                ~= "war" then


if pendingWar == nil
    and activeNAP == nil
    and not isAllied then


                    UI.CreateButton(row)
                        .SetText(
                            "DECLARE WAR"
                        )
                        .SetOnClick(function()


                            game.SendGameCustomMessage(
                                "Declaring war...",
                                {

                                    type =
                                        "declareWar",

                                    targetPlayerID =
                                        playerID
                                },

                                function(
                                    result
                                )

                                    ShowDiplomacyMenu(
                                        parent,
                                        game
                                    );

                                end
                            );

                        end);
                end


if activeNAP == nil
    and pendingWar == nil
    and not isAllied then


                    UI.CreateButton(row)
                        .SetText(
                            "PROPOSE 3-TURN NAP"
                        )
                        .SetOnClick(function()


                            game.SendGameCustomMessage(
                                "Sending Non-Aggression Pact proposal...",
                                {

                                    type =
                                        "sendNAPOffer",

                                    targetPlayerID =
                                        playerID,

                                    duration =
                                        3
                                },

                                function(
                                    result
                                )

                                    ShowDiplomacyMenu(
                                        parent,
                                        game
                                    );

                                end
                            );
                        end);
UI.CreateButton(row)
    .SetText(
        "PROPOSE ALLIANCE"
    )
    .SetOnClick(function()

        game.SendGameCustomMessage(
            "Sending Alliance proposal...",
            {

                type =
                    "proposeAlliance",

                targetPlayerID =
                    playerID

            },

            function(
                result
            )

                ShowDiplomacyMenu(
                    parent,
                    game
                );

            end
        );

    end);
                        
                end

if isAllied then

    local alliedPlayerID =
        playerID;


    UI.CreateButton(row)
        .SetText(
            "END ALLIANCE"
        )
        .SetOnClick(function()

            game.SendGameCustomMessage(
                "Ending Alliance...",
                {

                    type =
                        "endAlliance",

                    otherPlayerID =
                        alliedPlayerID
                },

                function(result)

                    if result ~= nil
                        and result.message ~= nil then

                        UI.Alert(
                            result.message
                        );

                    end


                    ShowDiplomacyMenu(
                        parent,
                        game
                    );

                end
            );

        end);

end

if ourFaction ~= nil
    and ourFaction.leaderPlayerID == ourID
    and playerFaction[
        targetID
    ] == nil
    and status ~= "war" then


    UI.CreateButton(row)
        .SetText(
            "INVITE TO FACTION"
        )
        .SetOnClick(function()

            game.SendGameCustomMessage(
                "Sending Faction invitation...",
                {

                    type =
                        "inviteToFaction",

                    targetPlayerID =
                        targetID

                },

                function(result)

                    if result ~= nil
                        and result.message ~= nil then

                        UI.Alert(
                            result.message
                        );

                    end


                    ShowDiplomacyMenu(
                        parent,
                        game
                    );

                end
            );

        end);

end

            -- =================================================
            -- WAR ACTIONS
            -- =================================================

            else


                UI.CreateButton(row)
                    .SetText(
                        "OFFER PEACE"
                    )
                    .SetOnClick(function()


                        game.SendGameCustomMessage(
                            "Sending peace offer...",
                            {

                                type =
                                    "sendPeaceOffer",

                                targetPlayerID =
                                    playerID
                            },

                            function(
                                result
                            )

                                ShowDiplomacyMenu(
                                    parent,
                                    game
                                );

                            end
                        );

                    end);
            end


            UI.CreateLabel(area)
                .SetText(
                    " "
                );

        end

    end


    if not foundRelation then


        UI.CreateLabel(area)
            .SetText(
                "No other active nations found."
            );
    end


    -- =====================================================
    -- INCOMING PEACE OFFERS
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "\nPEACE OFFERS"
        );


    local foundPeaceOffer =
        false;


    for _, offer
        in ipairs(
            pendingPeaceOffers
        ) do


        if offer.toPlayerID
            == ourID then


            foundPeaceOffer =
                true;


            local fromPlayer =
                game.Game.Players[
                    offer.fromPlayerID
                ];


local fromName =
    GetPlayerName(
        game,
        offer.fromPlayerID
    );


            local group =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            UI.CreateLabel(group)
                .SetText(
                    fromName ..
                    " is offering peace."
                );


            local buttons =
                UI.CreateHorizontalLayoutGroup(
                    group
                );


            local fromID =
                offer.fromPlayerID;


            UI.CreateButton(buttons)
                .SetText(
                    "ACCEPT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Accepting peace offer...",
                        {

                            type =
                                "acceptPeaceOffer",

                            fromPlayerID =
                                fromID
                        },

                        function(
                            result
                        )

                            ShowDiplomacyMenu(
                                parent,
                                game
                            );

                        end
                    );

                end);


            UI.CreateButton(buttons)
                .SetText(
                    "REJECT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Rejecting peace offer...",
                        {

                            type =
                                "rejectPeaceOffer",

                            fromPlayerID =
                                fromID
                        },

                        function(
                            result
                        )

                            ShowDiplomacyMenu(
                                parent,
                                game
                            );

                        end
                    );

                end);

        end

    end


    if not foundPeaceOffer then


        UI.CreateLabel(area)
            .SetText(
                "No incoming peace offers."
            );
    end


    -- =====================================================
    -- INCOMING NAP OFFERS
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "\nNON-AGGRESSION PACT OFFERS"
        );


    local foundNAPOffer =
        false;


    for _, offer
        in ipairs(
            pendingNAPOffers
        ) do


        if offer.toPlayerID
            == ourID then


            foundNAPOffer =
                true;


            local fromPlayer =
                game.Game.Players[
                    offer.fromPlayerID
                ];




local fromName =
    GetPlayerName(
        game,
        offer.fromPlayerID
    );

local group =
    UI.CreateVerticalLayoutGroup(
        area
    );

UI.CreateLabel(group)
                .SetText(
                    fromName ..
                    " proposed a " ..
                    tostring(
                        offer.duration
                        or 3
                    ) ..
                    "-turn Non-Aggression Pact."
                );


            local buttons =
                UI.CreateHorizontalLayoutGroup(
                    group
                );


            local fromID =
                offer.fromPlayerID;


            UI.CreateButton(buttons)
                .SetText(
                    "ACCEPT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Accepting Non-Aggression Pact...",
                        {

                            type =
                                "acceptNAPOffer",

                            fromPlayerID =
                                fromID
                        },

                        function(
                            result
                        )

                            ShowDiplomacyMenu(
                                parent,
                                game
                            );

                        end
                    );

                end);


            UI.CreateButton(buttons)
                .SetText(
                    "REJECT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Rejecting Non-Aggression Pact...",
                        {

                            type =
                                "rejectNAPOffer",

                            fromPlayerID =
                                fromID
                        },

                        function(
                            result
                        )

                            ShowDiplomacyMenu(
                                parent,
                                game
                            );

                        end
                    );

                end);

        end

    end


    if not foundNAPOffer then


        UI.CreateLabel(area)
            .SetText(
                "No incoming Non-Aggression Pact offers."
            );
    end

-- =====================================================
-- INCOMING ALLIANCE OFFERS
-- =====================================================

UI.CreateLabel(area)
    .SetText(
        "\nALLIANCE OFFERS"
    );


local foundAllianceOffer =
    false;


for _, offer
    in ipairs(
        pendingAllianceOffers
    ) do


    if offer.toPlayerID
        == ourID then


        foundAllianceOffer =
            true;


        local fromName =
            GetPlayerName(
                game,
                offer.fromPlayerID
            );


        local group =
            UI.CreateVerticalLayoutGroup(
                area
            );


        UI.CreateLabel(group)
            .SetText(
                fromName ..
                " proposed an Alliance."
            );


        local buttons =
            UI.CreateHorizontalLayoutGroup(
                group
            );


        local fromID =
            offer.fromPlayerID;


        UI.CreateButton(buttons)
            .SetText(
                "ACCEPT"
            )
            .SetOnClick(function()


                game.SendGameCustomMessage(
                    "Accepting Alliance proposal...",
                    {

                        type =
                            "acceptAllianceOffer",

                        fromPlayerID =
                            fromID
                    },

                    function(result)

                        if result ~= nil
                            and result.message ~= nil then

                            UI.Alert(
                                result.message
                            );

                        end


                        ShowDiplomacyMenu(
                            parent,
                            game
                        );

                    end
                );

            end);


        UI.CreateButton(buttons)
            .SetText(
                "REJECT"
            )
            .SetOnClick(function()


                game.SendGameCustomMessage(
                    "Rejecting Alliance proposal...",
                    {

                        type =
                            "rejectAllianceOffer",

                        fromPlayerID =
                            fromID
                    },

                    function(result)

                        if result ~= nil
                            and result.message ~= nil then

                            UI.Alert(
                                result.message
                            );

                        end


                        ShowDiplomacyMenu(
                            parent,
                            game
                        );

                    end
                );

            end);

    end

end


if not foundAllianceOffer then

    UI.CreateLabel(area)
        .SetText(
            "No incoming Alliance offers."
        );

end

-- =====================================================
-- FACTIONS
-- =====================================================

UI.CreateLabel(area)
    .SetText(
        "\nFACTIONS"
    );


if ourFaction == nil then

    UI.CreateLabel(area)
        .SetText(
            "Your nation does not currently belong to a Faction."
        );


    local factionNameInput =
        UI.CreateTextInputField(
            area
        )
            .SetPlaceholderText(
                "Enter Faction name..."
            );


    UI.CreateButton(area)
        .SetText(
            "CREATE FACTION"
        )
        .SetOnClick(function()

            local factionName =
                factionNameInput.GetText();


            game.SendGameCustomMessage(
                "Creating Faction...",
                {

                    type =
                        "createFaction",

                    factionName =
                        factionName

                },

                function(result)

                    if result ~= nil
                        and result.message ~= nil then

                        UI.Alert(
                            result.message
                        );

                    end


                    ShowDiplomacyMenu(
                        parent,
                        game
                    );

                end
            );

        end);


else

    UI.CreateLabel(area)
        .SetText(
            "Faction: " ..
            tostring(
                ourFaction.name
                or "Unnamed Faction"
            )
        );


    local leaderName =
        GetPlayerName(
            game,
            ourFaction.leaderPlayerID
        );


    UI.CreateLabel(area)
        .SetText(
            "Leader: " ..
            leaderName
        );


    UI.CreateLabel(area)
        .SetText(
            "Members:"
        );


    for memberID, isMember in pairs(
        ourFaction.members
        or {}
    ) do

        if isMember == true then

            local memberName =
                GetPlayerName(
                    game,
                    memberID
                );


            local memberGroup =
                UI.CreateHorizontalLayoutGroup(
                    area
                );


            local memberText =
                memberName;


            if memberID
                == ourFaction.leaderPlayerID then

                memberText =
                    memberText ..
                    " | LEADER";

            end


            UI.CreateLabel(memberGroup)
                .SetText(
                    memberText
                );


            if ourFaction.leaderPlayerID
                == ourID
                and memberID
                ~= ourID then

                local removableID =
                    memberID;


                UI.CreateButton(memberGroup)
                    .SetText(
                        "REMOVE"
                    )
                    .SetOnClick(function()

                        game.SendGameCustomMessage(
                            "Removing Faction member...",
                            {

                                type =
                                    "removeFactionMember",

                                targetPlayerID =
                                    removableID

                            },

                            function(result)

                                if result ~= nil
                                    and result.message ~= nil then

                                    UI.Alert(
                                        result.message
                                    );

                                end


                                ShowDiplomacyMenu(
                                    parent,
                                    game
                                );

                            end
                        );

                    end);

            end

        end

    end


    if ourFaction.leaderPlayerID
        ~= ourID then

        UI.CreateButton(area)
            .SetText(
                "LEAVE FACTION"
            )
            .SetOnClick(function()

                game.SendGameCustomMessage(
                    "Leaving Faction...",
                    {

                        type =
                            "leaveFaction"

                    },

                    function(result)

                        if result ~= nil
                            and result.message ~= nil then

                            UI.Alert(
                                result.message
                            );

                        end


                        ShowDiplomacyMenu(
                            parent,
                            game
                        );

                    end
                );

            end);

    else

        UI.CreateLabel(area)
            .SetText(
                "As Faction leader, you manage invitations and membership."
            );



    UI.CreateButton(area)
        .SetText(
            "DISBAND FACTION"
        )
        .SetOnClick(function()

            game.SendGameCustomMessage(
                "Disbanding Faction...",
                {

                    type =
                        "disbandFaction"

                },

                function(result)

                    if result ~= nil
                        and result.message ~= nil then

                        UI.Alert(
                            result.message
                        );

                    end


                    ShowDiplomacyMenu(
                        parent,
                        game
                    );

                end
            );

        end);

end
    end



-- =====================================================
-- INCOMING FACTION INVITATIONS
-- =====================================================

UI.CreateLabel(area)
    .SetText(
        "\nFACTION INVITATIONS"
    );


local foundFactionInvite =
    false;


for _, invite in ipairs(
    pendingFactionInvites
) do

    if invite.toPlayerID
        == ourID then

        foundFactionInvite =
            true;


        local faction =
            factions[
                invite.factionID
            ];


        local factionName =
            faction ~= nil
            and faction.name
            or "Unknown Faction";


        local inviterName =
            GetPlayerName(
                game,
                invite.fromPlayerID
            );


        local inviteGroup =
            UI.CreateVerticalLayoutGroup(
                area
            );


        UI.CreateLabel(inviteGroup)
            .SetText(
                inviterName ..
                " invited you to join \"" ..
                tostring(
                    factionName
                ) ..
                "\"."
            );


        local buttons =
            UI.CreateHorizontalLayoutGroup(
                inviteGroup
            );


        local selectedFactionID =
            invite.factionID;


        UI.CreateButton(buttons)
            .SetText(
                "ACCEPT"
            )
            .SetOnClick(function()

                game.SendGameCustomMessage(
                    "Accepting Faction invitation...",
                    {

                        type =
                            "acceptFactionInvite",

                        factionID =
                            selectedFactionID

                    },

                    function(result)

                        if result ~= nil
                            and result.message ~= nil then

                            UI.Alert(
                                result.message
                            );

                        end


                        ShowDiplomacyMenu(
                            parent,
                            game
                        );

                    end
                );

            end);


        UI.CreateButton(buttons)
            .SetText(
                "REJECT"
            )
            .SetOnClick(function()

                game.SendGameCustomMessage(
                    "Rejecting Faction invitation...",
                    {

                        type =
                            "rejectFactionInvite",

                        factionID =
                            selectedFactionID

                    },

                    function(result)

                        if result ~= nil
                            and result.message ~= nil then

                            UI.Alert(
                                result.message
                            );

                        end


                        ShowDiplomacyMenu(
                            parent,
                            game
                        );

                    end
                );

            end);

    end

end


if not foundFactionInvite then

    UI.CreateLabel(area)
        .SetText(
            "No incoming Faction invitations."
        );

end

    -- =====================================================
    -- DIPLOMACY HISTORY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "\nDIPLOMACY HISTORY"
        );


    if #history == 0 then


        UI.CreateLabel(area)
            .SetText(
                "No diplomacy events yet."
            );


    else


        local startIndex =
            math.max(
                1,
                #history - 9
            );


        for i =
            #history,
            startIndex,
            -1 do


            local event =
                history[
                    i
                ];


            UI.CreateLabel(area)
                .SetText(
                    "Turn " ..
                    tostring(
                        event.turn
                        or "?"
                    ) ..
                    " - " ..
                    tostring(
                        event.message
                        or event.type
                        or "Diplomacy event"
                    )
                );

        end

    end
end


function ShowTradeAgreementsMenu(parent, game)

    local area =
        CreateContentArea(parent);

    UI.CreateLabel(area)
        .SetText(
            "TRADE AGREEMENTS"
        );

    UI.CreateLabel(area)
        .SetText(
            "Stable recurring income based on the Commerce strength of your partners."
        );

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    local nav =
        UI.CreateHorizontalLayoutGroup(area);

    UI.CreateButton(nav)
        .SetText(
            "Find Partners"
        )
        .SetOnClick(function()

            ShowFindPartners(
                parent,
                game
            );

        end);

    UI.CreateButton(nav)
        .SetText(
            "My Agreements"
        )
        .SetOnClick(function()

            ShowMyAgreements(
                parent,
                game
            );

        end);

    UI.CreateLabel(area)
        .SetText(
            "\nUse Find Partners to review nations and send proposals. Use My Agreements to manage incoming, outgoing, and active agreements."
        );
end


function ShowMarketsMenu(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    UI.CreateLabel(area)
        .SetText(
            "MARKETS"
        );

    UI.CreateLabel(area)
        .SetText(
            "Stocks | Portfolio | Rankings | Price History"
        );

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    UI.CreateButton(area)
        .SetText(
            "STOCK MARKET"
        )
        .SetOnClick(function()

            ShowStockMarket(
                parent,
                game
            );

        end);

    UI.CreateButton(area)
        .SetText(
            "MY PORTFOLIO"
        )
        .SetOnClick(function()

            ShowStockPortfolio(
                parent,
                game
            );

        end);

    UI.CreateButton(area)
        .SetText(
            "MARKET OVERVIEW"
        )
        .SetOnClick(function()

            ShowMarketOverview(
                parent,
                game
            );

        end);

    UI.CreateButton(area)
    .SetText(
        "MARKET NEWS"
    )
    .SetOnClick(function()

        ShowMarketNews(
            parent,
            game
        );

    end);
    
UI.CreateButton(area)
    .SetText(
        "GLOBAL MARKET ETF"
    )
    .SetOnClick(function()

        ShowMarketETF(
            parent,
            game
        );

    end);

end



-- =========================================================
-- SHARED TAX / IDEOLOGY PREVIEW
-- =========================================================

function GetPolicyPreviewText(
    game,
    taxPolicy,
    ideology
)

    local taxCommerce = 0;
    local taxMarket = 0;
    local taxInvestment = 0;
    local taxConfidence = 0;

    if taxPolicy == "Low" then

        taxCommerce = -10;
        taxMarket = 10;
        taxInvestment = 10;
        taxConfidence = 5;

    elseif taxPolicy == "High" then

        taxCommerce = 10;
        taxMarket = -10;
        taxInvestment = -10;
        taxConfidence = -5;

    end

    local ideologyCommerce = 0;
    local ideologyMarket = 0;
    local ideologyInvestment = 0;
    local ideologyConfidence = 0;

    if ideology == "Free Market" then

        ideologyCommerce = -3;
        ideologyMarket = 8;
        ideologyInvestment = 6;
        ideologyConfidence = 2;

    elseif ideology == "Capitalist" then

        ideologyCommerce = -2;
        ideologyMarket = 6;
        ideologyInvestment = 5;
        ideologyConfidence = 3;

    elseif ideology == "Social Democratic" then

        ideologyCommerce = 2;
        ideologyMarket = 2;
        ideologyInvestment = 3;
        ideologyConfidence = 2;

    elseif ideology == "State Capitalist" then

        ideologyCommerce = 4;
        ideologyMarket = 1;
        ideologyInvestment = 5;
        ideologyConfidence = 4;

    elseif ideology == "Socialist" then

        ideologyCommerce = 5;
        ideologyMarket = -5;
        ideologyInvestment = 1;
        ideologyConfidence = 1;

    elseif ideology == "Communist" then

        ideologyCommerce = 7;
        ideologyMarket = -9;
        ideologyInvestment = -2;
        ideologyConfidence = 0;

    elseif ideology == "Fascist" then

        ideologyCommerce = 3;
        ideologyMarket = -2;
        ideologyInvestment = 1;
        ideologyConfidence = 3;

    elseif ideology == "Nationalist" then

        ideologyCommerce = 2;
        ideologyMarket = -1;
        ideologyInvestment = 0;
        ideologyConfidence = 2;

    end

    local totalCommerce =
        taxCommerce
        + ideologyCommerce;

    local totalMarket =
        taxMarket
        + ideologyMarket;

    local totalInvestment =
        taxInvestment
        + ideologyInvestment;

    local totalConfidence =
        taxConfidence
        + ideologyConfidence;

    local currentCommerce =
        0;

    if game ~= nil
        and game.Us ~= nil
    then

        currentCommerce =
            GetPlayerIncome(
                game,
                game.Us.ID
            )
            or 0;

    end

    local projectedCommerce =
        math.floor(
            currentCommerce
            * (
                1
                + totalCommerce / 100
            )
            + 0.5
        );

    local function SignedNumber(
        value,
        suffix
    )

        if value > 0 then

            return
                "+"
                .. tostring(value)
                .. suffix;

        end

        return
            tostring(value)
            .. suffix;

    end

    return
        "Combined Policy Impact\n" ..
        "Commerce: " ..
        SignedNumber(totalCommerce, "%") ..
        " | Market: " ..
        SignedNumber(totalMarket, "%") ..
        " | Investment: " ..
        SignedNumber(totalInvestment, "%") ..
        " | Company Confidence: " ..
        SignedNumber(totalConfidence, "") ..
        "\nEstimated Commerce/Turn: " ..
        tostring(currentCommerce) ..
        " -> ~" ..
        tostring(projectedCommerce);

end

function ShowTaxationMenu(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    local nation =
        GetOurNationState(
            game
        );


    UI.CreateLabel(area)
        .SetText(
            "TAXATION & IDEOLOGY"
        );


    if nation == nil
        or nation.setupComplete ~= true then

        UI.CreateLabel(area)
            .SetText(
                "Complete National Setup to access taxation and ideology details."
            );

        return;
    end


    UI.CreateLabel(area)
        .SetText(
            "Current Tax Policy: " ..
            tostring(
                nation.taxPolicy
                or "Standard"
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Current Ideology: " ..
            tostring(
                nation.ideology
                or "Unknown"
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "--------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            GetPolicyPreviewText(
                game,
                nation.taxPolicy
                    or "Standard",
                nation.ideology
                    or "Social Democratic"
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "--------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "Low Tax\n" ..
            "-10% Commerce | +10% Market | +10% Investment | +5 Confidence\n\n" ..

            "Standard Tax\n" ..
            "0% Commerce | 0% Market | 0% Investment | 0 Confidence\n\n" ..

            "High Tax\n" ..
            "+10% Commerce | -10% Market | -10% Investment | -5 Confidence"
        );

end


function ShowUnitedNationsMenu(parent, game)

    ShowComingSoonSection(
        parent,
        "UNITED NATIONS",
        "Active Vote | Proposals | Resolutions | Public Enemy | Leadership | Sanctions | Aid | History\n\nThe UN will use simple YES / NO voting, optional reasons, discussion, vote graphs, sanctions, aid, Public Enemy rules, and leadership succession."
    );
end


function ShowCustomizeTabs(
    parent,
    game,
    tabsHost
)

    local area =
        CreateContentArea(parent);

    UI.CreateLabel(area)
        .SetText(
            "CUSTOMIZE MENU"
        );

    UI.CreateLabel(area)
        .SetText(
            "Hide optional tabs you do not want displayed. Hiding a tab does not disable that feature or stop its effects."
        );

    UI.CreateLabel(area)
        .SetText(
            "Overview, Diplomacy, and Trade Agreements always remain visible because they contain core game information."
        );

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    local investmentsBox =
        UI.CreateCheckBox(area)
            .SetText(
                "Show Investments"
            )
            .SetIsChecked(
                PlayerTabVisibility.investments
            );

    local marketsBox =
        UI.CreateCheckBox(area)
            .SetText(
                "Show Markets"
            )
            .SetIsChecked(
                PlayerTabVisibility.markets
            );

    local taxationBox =
        UI.CreateCheckBox(area)
            .SetText(
                "Show Taxation"
            )
            .SetIsChecked(
                PlayerTabVisibility.taxation
            );


    local globalBox =
        UI.CreateCheckBox(area)
            .SetText(
                "Show Global Economy"
            )
            .SetIsChecked(
                PlayerTabVisibility.globalEconomy
            );

    local helpBox =
        UI.CreateCheckBox(area)
            .SetText(
                "Show How It Works"
            )
            .SetIsChecked(
                PlayerTabVisibility.howItWorks
            );

    UI.CreateButton(area)
        .SetText(
            "APPLY TAB CHANGES"
        )
        .SetOnClick(function()

            PlayerTabVisibility.investments =
                investmentsBox.GetIsChecked();

            PlayerTabVisibility.markets =
                marketsBox.GetIsChecked();

            PlayerTabVisibility.taxation =
                taxationBox.GetIsChecked();

            PlayerTabVisibility.globalEconomy =
                globalBox.GetIsChecked();

            PlayerTabVisibility.howItWorks =
                helpBox.GetIsChecked();

            BuildMainTabs(
                tabsHost,
                parent,
                game
            );

            UI.Alert(
                "Menu tabs updated. Hidden tabs remain active in the game and can be restored from Customize Tabs."
            );

        end);

    UI.CreateButton(area)
        .SetText(
            "RESET TABS TO DEFAULT"
        )
        .SetOnClick(function()

            PlayerTabVisibility.investments = true;
            PlayerTabVisibility.markets = true;
            PlayerTabVisibility.taxation = true;
            PlayerTabVisibility.globalEconomy = true;
            PlayerTabVisibility.howItWorks = true;

            BuildMainTabs(
                tabsHost,
                parent,
                game
            );

            UI.Alert(
                "All optional tabs are visible again."
            );

        end);
end


-- =========================================================
-- STRATEGIC RESOURCES UI
-- =========================================================

local RESOURCE_UI_TYPES = {
    "Oil", "Gas", "Uranium", "Iron", "Food", "Rare Earths",
    "Coal", "Copper", "Lithium"
};

local function ResourceTypeAvailable(resourceName)
    if resourceName == "Coal" or resourceName == "Copper" or resourceName == "Lithium" then
        return GetClientSetting("AdvancedResourcesEnabled", true);
    end
    return true;
end

local function ResourceAmountText(values)
    local parts = {};
    for _, resourceName in ipairs(RESOURCE_UI_TYPES) do
        if ResourceTypeAvailable(resourceName) then
            table.insert(parts, resourceName .. ": " .. tostring((values or {})[resourceName] or 0));
        end
    end
    return table.concat(parts, " | ");
end

function ShowResourcesMenu(parent, game)
    local area = CreateContentArea(parent);
    local data = Mod.PublicGameData or {};
    local economy = data.globalEconomy or {};
    local resources = economy.resources or {};
    local nation = (economy.nations or {})[game.Us.ID] or {};

    UI.CreateLabel(area).SetText("STRATEGIC RESOURCES");

    if GetClientSetting("ResourcesEnabled", true) ~= true then
        UI.CreateLabel(area).SetText("The host has disabled Strategic Resources.");
        return;
    end

    UI.CreateLabel(area).SetText("Production / Turn");
    UI.CreateLabel(area).SetText(ResourceAmountText(nation.resourceProduction));
    UI.CreateLabel(area).SetText("Effective After Trades");
    UI.CreateLabel(area).SetText(ResourceAmountText(nation.resourceEffective));

    local penalty = nation.resourcePenaltyPercent or 0;
    local readiness = nation.resourceMilitaryReadiness or 100;
    local unrest = nation.resourceUnrest or 0;
    UI.CreateLabel(area).SetText(
        "Resource Penalty: -" .. tostring(penalty) .. "% Commerce / mobilization" ..
        " | Military Readiness: " .. tostring(readiness) .. "%" ..
        " | Unrest: " .. tostring(unrest)
    );

    local shortages = nation.resourceShortages or {};
    local shortageParts = {};
    for resourceName, amount in pairs(shortages) do
        table.insert(shortageParts, resourceName .. " -" .. tostring(amount));
    end
    table.sort(shortageParts);
    UI.CreateLabel(area).SetText(
        #shortageParts > 0 and ("Shortages: " .. table.concat(shortageParts, ", "))
        or "Shortages: None"
    );

    UI.CreateLabel(area).SetText("----------------------------------------");
    UI.CreateLabel(area).SetText("DEVELOP RESOURCE FACILITY");
    UI.CreateLabel(area).SetText(
        "Choose a resource, then click SELECT TERRITORY. Existing deposits can be upgraded; a new facility may also be established on an owned territory at a higher cost. The change is applied next turn. Each resource territory shows ONE Resource Hub icon; the number beside it is the total facility/deposit level on that territory."
    );

    local selectedResource = "Oil";
    local selectedLabel = UI.CreateLabel(area).SetText("Selected Resource: Oil");

    local row = nil;
    local visibleIndex = 0;
    for _, resourceName in ipairs(RESOURCE_UI_TYPES) do
        if ResourceTypeAvailable(resourceName) then
            visibleIndex = visibleIndex + 1;
            if (visibleIndex - 1) % 3 == 0 then row = UI.CreateHorizontalLayoutGroup(area); end
            local captured = resourceName;
            UI.CreateButton(row)
                .SetText(captured)
                .SetOnClick(function()
                    selectedResource = captured;
                    selectedLabel.SetText("Selected Resource: " .. captured);
                end);
        end
    end

    local territoryStatus = UI.CreateLabel(area).SetText("");
    UI.CreateButton(area)
        .SetText("SELECT TERRITORY TO UPGRADE")
        .SetOnClick(function()
            territoryStatus.SetText("Click one of your territories containing " .. selectedResource .. ".");
            UI.InterceptNextTerritoryClick(function(terrDetails)
                if terrDetails == nil then
                    territoryStatus.SetText("Territory selection canceled.");
                    return;
                end
                local territoryID = terrDetails.ID;
                territoryStatus.SetText("Scheduling upgrade...");
                game.SendGameCustomMessage(
                    "Scheduling resource facility...",
                    {type="buildResourceFacility", territoryID=territoryID, resource=selectedResource},
                    function(result)
                        if result ~= nil and result.message ~= nil then UI.Alert(result.message); end
                        ShowResourcesMenu(parent, game);
                    end
                );
            end);
        end);

    if GetClientSetting("ResourceTradingEnabled", true) == true then
        UI.CreateLabel(area).SetText("----------------------------------------");
        UI.CreateLabel(area).SetText("RESOURCE TRADE CONTRACTS");
        UI.CreateLabel(area).SetText("Contracts transfer current-turn production every turn; resources are not stockpiled.");

        local tradeResource = "Oil";
        local tradeAmount = 1;
        local tradePrice = 25;
        local targetPlayerID = nil;
        local tradeLabel = UI.CreateLabel(area).SetText("Offer: 1 Oil @ 25 gold/unit | Partner: None");

        local function RefreshTradeLabel()
            local targetName = targetPlayerID and GetPlayerName(game, targetPlayerID) or "None";
            tradeLabel.SetText(
                "Offer: " .. tostring(tradeAmount) .. " " .. tradeResource ..
                " @ " .. tostring(tradePrice) .. " gold/unit | Partner: " .. targetName
            );
        end

        local rrow = nil;
        local resourceButtonIndex = 0;
        for _, resourceName in ipairs({"Oil","Gas","Iron","Food","Uranium","Rare Earths"}) do
            if ResourceTypeAvailable(resourceName) then
                resourceButtonIndex = resourceButtonIndex + 1;
                if (resourceButtonIndex - 1) % 3 == 0 then
                    rrow = UI.CreateHorizontalLayoutGroup(area);
                end
                local captured = resourceName;
                UI.CreateButton(rrow).SetText(captured).SetOnClick(function()
                    tradeResource = captured; RefreshTradeLabel();
                end);
            end
        end

        local amountRow = UI.CreateHorizontalLayoutGroup(area);
        UI.CreateButton(amountRow).SetText("-1 UNIT").SetOnClick(function()
            tradeAmount = math.max(1, tradeAmount - 1); RefreshTradeLabel();
        end);
        UI.CreateButton(amountRow).SetText("+1 UNIT").SetOnClick(function()
            tradeAmount = math.min(10, tradeAmount + 1); RefreshTradeLabel();
        end);
        UI.CreateButton(amountRow).SetText("-5 GOLD").SetOnClick(function()
            tradePrice = math.max(0, tradePrice - 5); RefreshTradeLabel();
        end);
        UI.CreateButton(amountRow).SetText("+5 GOLD").SetOnClick(function()
            tradePrice = math.min(500, tradePrice + 5); RefreshTradeLabel();
        end);

        UI.CreateLabel(area).SetText("Search Trade Partner");
        local searchInput = UI.CreateTextInputField(area);
        local searchHost = UI.CreateVerticalLayoutGroup(area);

        local function RefreshResourcePartnerSearch()
            if not UI.IsDestroyed(searchHost) then UI.Destroy(searchHost); end
            searchHost = UI.CreateVerticalLayoutGroup(area);
            local query = string.lower(searchInput.GetText() or "");
            local matches = {};
            for playerID, player in pairs(game.Game.Players or {}) do
                if playerID ~= game.Us.ID and not player.Surrendered then
                    local name = GetPlayerName(game, playerID);
                    if query == "" or string.find(string.lower(name), query, 1, true) ~= nil then
                        table.insert(matches, {id=playerID, name=name});
                    end
                end
            end
            table.sort(matches, function(a,b) return a.name < b.name; end);
            local prow = nil;
            for index, item in ipairs(matches) do
                if index > 30 then break; end
                if (index - 1) % 3 == 0 then prow = UI.CreateHorizontalLayoutGroup(searchHost); end
                local capturedID = item.id;
                UI.CreateButton(prow)
                    .SetText(item.name)
                    .SetTextColor(GetPlayerUIColor(game, item.id, "#FFFFFF"))
                    .SetOnClick(function()
                        targetPlayerID = capturedID;
                        RefreshTradeLabel();
                    end);
            end
        end

        searchInput.SetOnValueChanged(function() RefreshResourcePartnerSearch(); end);
        RefreshResourcePartnerSearch();

        UI.CreateButton(area).SetText("SEND RESOURCE OFFER").SetOnClick(function()
            if targetPlayerID == nil then UI.Alert("Select a trade partner first."); return; end
            game.SendGameCustomMessage(
                "Sending resource trade offer...",
                {type="proposeResourceTrade", targetPlayerID=targetPlayerID, resource=tradeResource, amount=tradeAmount, pricePerUnit=tradePrice},
                function(result)
                    if result ~= nil and result.message ~= nil then UI.Alert(result.message); end
                    ShowResourcesMenu(parent, game);
                end
            );
        end);

        UI.CreateLabel(area).SetText("INCOMING OFFERS");
        local foundIncoming = false;
        for _, offer in ipairs(resources.pendingOffers or {}) do
            if offer.toPlayerID == game.Us.ID then
                foundIncoming = true;
                local offerID = offer.id;
                local offerRow = UI.CreateHorizontalLayoutGroup(area);
                UI.CreateLabel(offerRow).SetText(
                    GetPlayerName(game, offer.fromPlayerID) .. ": " .. tostring(offer.amount) .. " " .. offer.resource ..
                    " @ " .. tostring(offer.pricePerUnit) .. " gold/unit"
                );
                UI.CreateButton(offerRow).SetText("ACCEPT").SetOnClick(function()
                    game.SendGameCustomMessage("Accepting resource trade...", {type="acceptResourceTrade", offerID=offerID}, function(result)
                        if result ~= nil and result.message ~= nil then UI.Alert(result.message); end
                        ShowResourcesMenu(parent, game);
                    end);
                end);
                UI.CreateButton(offerRow).SetText("REJECT").SetOnClick(function()
                    game.SendGameCustomMessage("Rejecting resource trade...", {type="rejectResourceTrade", offerID=offerID}, function(result)
                        if result ~= nil and result.message ~= nil then UI.Alert(result.message); end
                        ShowResourcesMenu(parent, game);
                    end);
                end);
            end
        end
        if not foundIncoming then UI.CreateLabel(area).SetText("No incoming resource offers."); end

        UI.CreateLabel(area).SetText("ACTIVE CONTRACTS");
        local foundActive = false;
        for tradeIndex, trade in ipairs(resources.activeTrades or {}) do
            if trade.fromPlayerID == game.Us.ID or trade.toPlayerID == game.Us.ID then
                foundActive = true;
                local capturedIndex = tradeIndex;
                local direction = trade.fromPlayerID == game.Us.ID and "EXPORT" or "IMPORT";
                local otherID = trade.fromPlayerID == game.Us.ID and trade.toPlayerID or trade.fromPlayerID;
                local activeRow = UI.CreateHorizontalLayoutGroup(area);
                UI.CreateLabel(activeRow).SetText(
                    direction .. " " .. tostring(trade.amount) .. " " .. trade.resource ..
                    " with " .. GetPlayerName(game, otherID) .. " @ " .. tostring(trade.pricePerUnit) ..
                    " | Last delivered: " .. tostring(trade.lastTransferred or 0)
                );
                UI.CreateButton(activeRow).SetText("CANCEL").SetOnClick(function()
                    game.SendGameCustomMessage("Canceling resource contract...", {type="cancelResourceTrade", tradeIndex=capturedIndex}, function(result)
                        if result ~= nil and result.message ~= nil then UI.Alert(result.message); end
                        ShowResourcesMenu(parent, game);
                    end);
                end);
            end
        end
        if not foundActive then UI.CreateLabel(area).SetText("No active resource contracts."); end
    end
end


function BuildMainTabs(
    tabsHost,
    contentHost,
    game
)

    if MainTabsArea ~= nil
        and not UI.IsDestroyed(
            MainTabsArea
        )
    then

        UI.Destroy(
            MainTabsArea
        );

    end

    MainTabsArea =
        UI.CreateVerticalLayoutGroup(
            tabsHost
        );

    local tabs =
        {};

    local function QueueTab(
        key,
        label,
        buttonColor,
        textColor,
        onClick
    )

        table.insert(
            tabs,
            {
                key = key,
                label = label,
                buttonColor = buttonColor,
                textColor = textColor,
                onClick = onClick
            }
        );

    end

    QueueTab(
        "overview",
        "Overview",
        "#4169E1",
        "#FFFFFF",
        function()
            ShowOverview(contentHost, game);
        end
    );

    QueueTab(
        "diplomacy",
        "Diplomacy",
        "#FF7D00",
        "#FFFFFF",
        function()
            ShowDiplomacyMenu(contentHost, game);
        end
    );

    QueueTab(
        "trade",
        "Trade Agreements",
        "#359029",
        "#FFFFFF",
        function()
            ShowTradeAgreementsMenu(contentHost, game);
        end
    );

    if PlayerTabVisibility.investments then
        QueueTab(
            "investments",
            "Investments",
            "#59009D",
            "#FFFFFF",
            function()
                ShowInvestments(contentHost, game);
            end
        );
    end

    if PlayerTabVisibility.markets then
        QueueTab(
            "markets",
            "Markets",
            "#DAA520",
            "#000000",
            function()
                ShowMarketsMenu(contentHost, game);
            end
        );
    end

    if PlayerTabVisibility.taxation then
        QueueTab(
            "taxation",
            "Taxation",
            "#1274A4",
            "#FFFFFF",
            function()
                ShowTaxationMenu(contentHost, game);
            end
        );
    end

    if GetClientSetting(
        "ResourcesEnabled",
        true
    ) then
        QueueTab(
            "resources",
            "Resources",
            "#2E8B57",
            "#FFFFFF",
            function()
                ShowResourcesMenu(
                    contentHost,
                    game
                );
            end
        );
    end

    if PlayerTabVisibility.globalEconomy then
        QueueTab(
            "global",
            "Global Economy",
            "#B03B3B",
            "#FFFFFF",
            function()
                ShowGlobalEconomy(
                    contentHost,
                    game,
                    "all"
                );
            end
        );
    end

    if PlayerTabVisibility.howItWorks then
        QueueTab(
            "help",
            "How It Works",
            "#606060",
            "#FFFFFF",
            function()
                ShowHowItWorks(contentHost);
            end
        );
    end

    QueueTab(
        "customize",
        "Customize Tabs",
        "#BABABC",
        "#000000",
        function()
            ShowCustomizeTabs(
                contentHost,
                game,
                tabsHost
            );
        end
    );

    local row = nil;

    for index, tab
        in ipairs(tabs)
    do

        if (index - 1) % 2 == 0 then

            row =
                UI.CreateHorizontalLayoutGroup(
                    MainTabsArea
                );

        end

        local tabButton =
            UI.CreateButton(row)
                .SetText(
                    MainTabText(
                        tab.key,
                        tab.label
                    )
                )
                .SetColor(
                    tab.buttonColor
                )
                .SetTextColor(
                    tab.textColor
                )
                .SetFlexibleWidth(1)
                .SetPreferredHeight(40)
                .SetOnClick(function()

                    ActiveMainTab =
                        tab.key;

                    BuildMainTabs(
                        tabsHost,
                        contentHost,
                        game
                    );

                    tab.onClick();

                end);

        if ActiveMainTab == tab.key then

            tabButton.SetPreferredHeight(
                44
            );

        end

    end
end


function Client_PresentMenuUI(
    rootParent,
    setMaxSize,
    setScrollable,
    game,
    close
)

    ContentArea = nil;
    MainTabsArea = nil;
    ActiveMainTab = "overview";

    setMaxSize(
        1100,
        760
    );

    setScrollable(
        false,
        true
    );

    local main =
        UI.CreateVerticalLayoutGroup(
            rootParent
        );

    local tabsHost =
        UI.CreateVerticalLayoutGroup(
            main
        );

    local contentHost =
        UI.CreateVerticalLayoutGroup(
            main
        );

    BuildMainTabs(
        tabsHost,
        contentHost,
        game
    );

    if IsNationalSetupComplete(
        game
    ) then

        ShowOverview(
            contentHost,
            game
        );

    else

        ShowNationalSetup(
            contentHost,
            game
        );

    end
end


function ClearContent()

    if ContentArea ~= nil then

        if not UI.IsDestroyed(
            ContentArea
        ) then

            UI.Destroy(
                ContentArea
            );
        end

        ContentArea = nil;
    end
end


function CreateContentArea(parent)

    ClearContent();

    ContentArea =
        UI.CreateVerticalLayoutGroup(
            parent
        );

    return ContentArea;
end


function TradePairKey(
    playerA,
    playerB
)

    local a =
        tostring(playerA);

    local b =
        tostring(playerB);

    if a < b then
        return a .. "|" .. b;
    else
        return b .. "|" .. a;
    end
end


function GetCooldownTurnsRemaining(
    data,
    playerA,
    playerB
)

    local cooldowns =
        data.cooldowns or {};

    local currentTurn =
        data.tradeTurn or 0;

    local key =
        TradePairKey(
            playerA,
            playerB
        );

    local untilTurn =
        cooldowns[key];

    if untilTurn == nil then
        return 0;
    end

    local remaining =
        untilTurn
        - currentTurn;

    if remaining < 0 then
        remaining = 0;
    end

    return remaining;
end


function CountOurActiveAgreements(
    data,
    game
)

    local count = 0;

    for _, agreement
        in pairs(
            data.activeAgreements
            or {}
        ) do

        if agreement.player1
            == game.Us.ID

            or agreement.player2
            == game.Us.ID then

            count =
                count + 1;
        end
    end

    return count;
end


function GetPlayerName(
    game,
    playerID
)

    local player =
        game.Game.Players[
            playerID
        ];

    if player == nil then
        return "Unknown Player";
    end

    return player.DisplayName(
        nil,
        false
    );
end


function GetPlayerIncome(
    game,
    playerID
)

    local player =
        game.Game.Players[
            playerID
        ];

    if player == nil then
        return 0;
    end

    local info =
        player.Income(
            0,
            game.LatestStanding,
            true,
            false
        );

    if info == nil then
        return 0;
    end

    return info.Total or 0;
end
function GetPlayerGold(
    game,
    playerID
)

    if game.LatestStanding == nil then
        return 0;
    end


    return game.LatestStanding.NumResources(
        playerID,
        WL.ResourceType.Gold
    );

end

function CalculateTradeBonus(
    partnerIncome
)

    local percent =
        ClientTradeBonusPercent();

    return math.floor(
        (
            partnerIncome
            * (
                percent / 100
            )
        )
        + 0.5
    );
end


function CountOutsideProjectInvestors(
    project
)

    local count = 0;

    for _, investment
        in pairs(
            project.investments
            or {}
        ) do

        if investment.playerID
            ~= project.creatorID then

            count =
                count + 1;
        end
    end

    return count;
end


function GetOurProjectInvestment(
    project,
    game
)

    local amount = 0;

    for _, investment
        in pairs(
            project.investments
            or {}
        ) do

        if investment.playerID
            == game.Us.ID then

            amount =
                investment.amount
                or 0;

            break;
        end
    end

    return amount;
end


function GetEventCategory(
    eventType
)

    if eventType
        == "agreement_signed" then

        return "signed";
    end

    if eventType
        == "proposal_sent" then

        return "proposals";
    end

    if eventType
        == "proposal_rejected" then

        return "rejected";
    end

    if eventType
        == "agreement_canceled"

        or eventType
        == "agreement_ended"

        or eventType
        == "agreement_replaced" then

        return "canceled";
    end

    if eventType
        == "investment_created"

        or eventType
        == "investment_made"

        or eventType
        == "investment_funded" then

        return "investments";
    end

    if eventType
        == "investment_success" then

        return "success";
    end

    if eventType
        == "investment_failure"

        or eventType
        == "investment_expired" then

        return "failed";
    end

    if eventType
        == "ai_concern" then

        return "ai";
    end

    return "other";
end


function EventPassesFilter(
    eventType,
    filter
)

    if filter == "all" then
        return true;
    end

    return GetEventCategory(
        eventType
    ) == filter;
end
function ShowOverview(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    local activeCount =
        CountOurActiveAgreements(
            data,
            game
        );


    local incomingCount = 0;
    local outgoingCount = 0;
    local totalBonus = 0;


    for _, proposal
        in pairs(
            data.pendingProposals
            or {}
        ) do


        if proposal.toPlayerID
            == game.Us.ID then

            incomingCount =
                incomingCount + 1;


        elseif proposal.fromPlayerID
            == game.Us.ID then

            outgoingCount =
                outgoingCount + 1;
        end
    end


    for _, agreement
        in pairs(
            data.activeAgreements
            or {}
        ) do


        local otherID = nil;


        if agreement.player1
            == game.Us.ID then

            otherID =
                agreement.player2;


        elseif agreement.player2
            == game.Us.ID then

            otherID =
                agreement.player1;
        end


        if otherID ~= nil then


            totalBonus =
                totalBonus
                + CalculateTradeBonus(
                    GetPlayerIncome(
                        game,
                        otherID
                    )
                );
        end
    end


    local openProjects = 0;
    local activeProjects = 0;


    for _, project
        in pairs(
            data.investmentProjects
            or {}
        ) do


        if project.status
            == "funding" then

            openProjects =
                openProjects + 1;


        elseif project.status
            == "active" then

            activeProjects =
                activeProjects + 1;
        end
    end


    -- =====================================================
    -- NATIONAL SETUP / ECONOMIC REFORM
    -- =====================================================

    local nation =
        GetOurNationState(
            game
        );


    if nation == nil
        or nation.setupComplete ~= true then


        UI.CreateLabel(area)
            .SetText(
                "NATIONAL SETUP REQUIRED"
            );


        UI.CreateLabel(area)
            .SetText(
                "Complete your national economic setup to establish your ideology, economic strategy, tax policy, and flagship company."
            );


        UI.CreateButton(area)
            .SetText(
                "OPEN NATIONAL SETUP"
            )
            .SetOnClick(function()

                ShowNationalSetup(
                    parent,
                    game
                );

            end);


        UI.CreateLabel(area)
            .SetText(
                "----------------------------------------"
            );


    else


        UI.CreateLabel(area)
            .SetText(
                "YOUR NATION"
            );


        UI.CreateLabel(area)
            .SetText(
                "Ideology: " ..
                tostring(
                    nation.ideology
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Economic Strategy: " ..
                tostring(
                    nation.economicStrategy
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Tax Policy: " ..
                tostring(
                    nation.taxPolicy
                    or "Standard"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Flagship Company: " ..
                tostring(
                    nation.flagshipCompanyName
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Company Strategy: " ..
                tostring(
                    nation.companyStrategy
                    or "Unknown"
                )
            );


        -- =================================================
        -- ACTIVE ECONOMIC REFORM
        -- =================================================

        if nation.reformActive == true then


            local economyData =
                (
                    Mod.PublicGameData
                    or {}
                ).globalEconomy
                or {};


            local currentTurn =
                economyData.currentEconomyTurn
                or 1;


            local reformEndTurn =
                nation.reformEndTurn
                or currentTurn;


            local turnsRemaining =
                reformEndTurn
                - currentTurn;


            if turnsRemaining < 0 then

                turnsRemaining =
                    0;

            end


            UI.CreateLabel(area)
                .SetText(
                    "ECONOMIC REFORM IN PROGRESS"
                );


            UI.CreateLabel(area)
                .SetText(
                    "Temporary Reform Penalty: -15% Economic Confidence"
                );


            UI.CreateLabel(area)
                .SetText(
                    "Turns Remaining: " ..
                    tostring(
                        turnsRemaining
                    )
                );


            UI.CreateLabel(area)
                .SetText(
                    "Your new policies remain in effect after reform. The temporary penalty disappears when the reform period ends."
                );


        else


            UI.CreateButton(area)
                .SetText(
                    "VIEW / REFORM NATIONAL POLICY"
                )
                .SetOnClick(function()

                    ShowNationalSetup(
                        parent,
                        game
                    );

                end);

        end


        if GetClientSetting(
            "PlayerAIManagerEnabled",
            true
        ) == true then

            UI.CreateButton(area)
                .SetText(
                    "AI MANAGER"
                )
                .SetOnClick(function()

                    ShowAIManagerMenu(
                        parent,
                        game
                    );

                end);

        end

        UI.CreateLabel(area)
            .SetText(
                "----------------------------------------"
            );

    end


    -- =====================================================
    -- TRADE ECONOMY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "TRADE & INVESTMENT ECONOMY"
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "YOUR TRADE ECONOMY"
        );


    UI.CreateLabel(area)
        .SetText(
            "Active Agreements: " ..
            tostring(
                activeCount
            ) ..
            " / " ..
            tostring(
                ClientMaxAgreements()
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Incoming Proposals: " ..
            tostring(
                incomingCount
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Outgoing Proposals: " ..
            tostring(
                outgoingCount
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Current Trade Bonus: +" ..
            tostring(
                totalBonus
            ) ..
            " gold/turn"
        );


    UI.CreateLabel(area)
        .SetText(
            "Trade Benefit Rate: " ..
            tostring(
                ClientTradeBonusPercent()
            ) ..
            "% of partner Commerce income"
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- INVESTMENTS
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "GLOBAL INVESTMENT MARKET"
        );


    UI.CreateLabel(area)
        .SetText(
            "Open Projects: " ..
            tostring(
                openProjects
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Active Projects: " ..
            tostring(
                activeProjects
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Archived Projects: " ..
            tostring(
                #(
                    data.completedInvestmentProjects
                    or {}
                )
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- HOST RULES
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "HOST RULES"
        );


    UI.CreateLabel(area)
        .SetText(
            "Maximum Agreements: " ..
            tostring(
                ClientMaxAgreements()
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Trade Bonus: " ..
            tostring(
                ClientTradeBonusPercent()
            ) ..
            "%"
        );


    UI.CreateLabel(area)
        .SetText(
            "Trade Cooldown: " ..
            tostring(
                ClientTradeCooldownTurns()
            ) ..
            " turn(s)"
        );

end
function ShowFindPartners(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    UI.CreateLabel(area)
        .SetText(
            "FIND TRADE PARTNERS"
        );


    UI.CreateLabel(area)
        .SetText(
            "Review active nations and send Trade Agreement proposals."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    local ourID =
        game.Us.ID;


    local ourAgreementCount =
        CountOurActiveAgreements(
            data,
            game
        );


    if ourAgreementCount
        >= ClientMaxAgreements() then


        UI.CreateLabel(area)
            .SetText(
                "You already have the maximum number of active Trade Agreements."
            );


        return;

    end


    local foundAny =
        false;


    for playerID, player
        in pairs(
            game.Game.Players
        ) do


        if playerID ~= ourID
            and not player.Surrendered then


            foundAny =
                true;


            local targetID =
                playerID;


            local targetName =
                GetPlayerName(
                    game,
                    targetID
                );


            local targetIncome =
                GetPlayerIncome(
                    game,
                    targetID
                );


            local expectedBonus =
                CalculateTradeBonus(
                    targetIncome
                );


            local targetAgreementCount = 0;


            for _, agreement
                in pairs(
                    data.activeAgreements
                    or {}
                ) do


                if agreement.player1
                    == targetID

                    or agreement.player2
                    == targetID then


                    targetAgreementCount =
                        targetAgreementCount
                        + 1;

                end

            end


            local hasAgreement =
                false;


            for _, agreement
                in pairs(
                    data.activeAgreements
                    or {}
                ) do


                if
                    (
                        agreement.player1
                            == ourID

                        and agreement.player2
                            == targetID
                    )
                    or
                    (
                        agreement.player1
                            == targetID

                        and agreement.player2
                            == ourID
                    )
                then


                    hasAgreement =
                        true;


                    break;

                end

            end


            local hasPending =
                false;


            for _, proposal
                in pairs(
                    data.pendingProposals
                    or {}
                ) do


                if
                    (
                        proposal.fromPlayerID
                            == ourID

                        and proposal.toPlayerID
                            == targetID
                    )
                    or
                    (
                        proposal.fromPlayerID
                            == targetID

                        and proposal.toPlayerID
                            == ourID
                    )
                then


                    hasPending =
                        true;


                    break;

                end

            end


            local cooldownRemaining =
                GetCooldownTurnsRemaining(
                    data,
                    ourID,
                    targetID
                );


            local group =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            UI.CreateLabel(group)
                .SetText(
                    targetName
                );


            UI.CreateLabel(group)
                .SetText(
                    "Commerce Income: " ..
                    tostring(
                        targetIncome
                    )
                );


            UI.CreateLabel(group)
                .SetText(
                    "Estimated Trade Bonus: +" ..
                    tostring(
                        expectedBonus
                    ) ..
                    " gold/turn"
                );


            UI.CreateLabel(group)
                .SetText(
                    "Active Agreements: " ..
                    tostring(
                        targetAgreementCount
                    ) ..
                    " / " ..
                    tostring(
                        ClientMaxAgreements()
                    )
                );


            if hasAgreement then


                UI.CreateLabel(group)
                    .SetText(
                        "Status: ACTIVE TRADE AGREEMENT"
                    );


            elseif hasPending then


                UI.CreateLabel(group)
                    .SetText(
                        "Status: PROPOSAL ALREADY PENDING"
                    );


            elseif cooldownRemaining > 0 then


                UI.CreateLabel(group)
                    .SetText(
                        "Status: COOLDOWN - " ..
                        tostring(
                            cooldownRemaining
                        ) ..
                        " turn(s) remaining"
                    );


            elseif targetAgreementCount
                >= ClientMaxAgreements() then


                UI.CreateLabel(group)
                    .SetText(
                        "Status: PARTNER AT AGREEMENT LIMIT"
                    );


            else


                UI.CreateButton(group)
                    .SetText(
                        "PROPOSE TRADE AGREEMENT"
                    )
                    .SetOnClick(function()


                        game.SendGameCustomMessage(
                            "Sending trade proposal...",

                            {

                                type =
                                    "proposeTrade",

                                targetPlayerID =
                                    targetID

                            },

                            function(result)


                                UI.Alert(
                                    result
                                    and result.message
                                    or
                                    "Trade request processed."
                                );


                                if result ~= nil
                                    and result.success then


                                    ShowFindPartners(
                                        parent,
                                        game
                                    );

                                end

                            end
                        );

                    end);

            end


            UI.CreateLabel(group)
                .SetText(
                    "----------------------------------------"
                );

        end

    end


    if not foundAny then


        UI.CreateLabel(area)
            .SetText(
                "No eligible trade partners are currently available."
            );

    end

end


function ShowMyAgreements(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    local ourID =
        game.Us.ID;


    UI.CreateLabel(area)
        .SetText(
            "MY TRADE AGREEMENTS"
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "INCOMING PROPOSALS"
        );


    local incomingFound =
        false;


    for _, proposal
        in pairs(
            data.pendingProposals
            or {}
        ) do


        if proposal.toPlayerID
            == ourID then


            incomingFound =
                true;


            local fromID =
                proposal.fromPlayerID;


            local fromName =
                GetPlayerName(
                    game,
                    fromID
                );


            local expectedBonus =
                CalculateTradeBonus(
                    GetPlayerIncome(
                        game,
                        fromID
                    )
                );


            local group =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            UI.CreateLabel(group)
                .SetText(
                    fromName
                );


            UI.CreateLabel(group)
                .SetText(
                    "Estimated Benefit: +" ..
                    tostring(
                        expectedBonus
                    ) ..
                    " gold/turn"
                );


            local buttons =
                UI.CreateHorizontalLayoutGroup(
                    group
                );


            UI.CreateButton(buttons)
                .SetText(
                    "ACCEPT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Accepting trade proposal...",

                        {

                            type =
                                "acceptTrade",

                            fromPlayerID =
                                fromID

                        },

                        function(result)


                            UI.Alert(
                                result
                                and result.message
                                or
                                "Trade request processed."
                            );


                            if result ~= nil
                                and result.success then


                                ShowMyAgreements(
                                    parent,
                                    game
                                );

                            end

                        end
                    );

                end);


            UI.CreateButton(buttons)
                .SetText(
                    "REJECT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Rejecting trade proposal...",

                        {

                            type =
                                "rejectTrade",

                            fromPlayerID =
                                fromID

                        },

                        function(result)


                            UI.Alert(
                                result
                                and result.message
                                or
                                "Trade request processed."
                            );


                            ShowMyAgreements(
                                parent,
                                game
                            );

                        end
                    );

                end);


            UI.CreateLabel(group)
                .SetText(
                    "----------------------------------------"
                );

        end

    end


    if not incomingFound then


        UI.CreateLabel(area)
            .SetText(
                "No incoming trade proposals."
            );

    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "OUTGOING PROPOSALS"
        );


    local outgoingFound =
        false;


    for _, proposal
        in pairs(
            data.pendingProposals
            or {}
        ) do


        if proposal.fromPlayerID
            == ourID then


            outgoingFound =
                true;


            local targetName =
                GetPlayerName(
                    game,
                    proposal.toPlayerID
                );


            UI.CreateLabel(area)
                .SetText(
                    "Waiting for response from " ..
                    targetName
                );

        end

    end


    if not outgoingFound then


        UI.CreateLabel(area)
            .SetText(
                "No outgoing trade proposals."
            );

    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "ACTIVE AGREEMENTS"
        );


    local activeFound =
        false;


    for _, agreement
        in pairs(
            data.activeAgreements
            or {}
        ) do


        local otherID =
            nil;


        if agreement.player1
            == ourID then


            otherID =
                agreement.player2;


        elseif agreement.player2
            == ourID then


            otherID =
                agreement.player1;

        end


        if otherID ~= nil then


            activeFound =
                true;


            local selectedOtherID =
                otherID;


            local otherName =
                GetPlayerName(
                    game,
                    selectedOtherID
                );


            local partnerIncome =
                GetPlayerIncome(
                    game,
                    selectedOtherID
                );


            local bonus =
                CalculateTradeBonus(
                    partnerIncome
                );


            local group =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            UI.CreateLabel(group)
                .SetText(
                    otherName
                );


            UI.CreateLabel(group)
                .SetText(
                    "Partner Commerce: " ..
                    tostring(
                        partnerIncome
                    )
                );


            UI.CreateLabel(group)
                .SetText(
                    "Current Benefit: +" ..
                    tostring(
                        bonus
                    ) ..
                    " gold/turn"
                );


            UI.CreateLabel(group)
                .SetText(
                    "Agreement Started: Turn " ..
                    tostring(
                        agreement.startedTurn
                        or 0
                    )
                );


            UI.CreateButton(group)
                .SetText(
                    "CANCEL AGREEMENT"
                )
                .SetOnClick(function()


                    game.SendGameCustomMessage(
                        "Canceling trade agreement...",

                        {

                            type =
                                "cancelTrade",

                            otherPlayerID =
                                selectedOtherID

                        },

                        function(result)


                            UI.Alert(
                                result
                                and result.message
                                or
                                "Trade request processed."
                            );


                            if result ~= nil
                                and result.success then


                                ShowMyAgreements(
                                    parent,
                                    game
                                );

                            end

                        end
                    );

                end);


            UI.CreateLabel(group)
                .SetText(
                    "----------------------------------------"
                );

        end

    end


    if not activeFound then


        UI.CreateLabel(area)
            .SetText(
                "You do not currently have any active Trade Agreements."
            );

    end

end

function ShowStockMarket(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    local data =
        Mod.PublicGameData
        or {};

    local economy =
        data.globalEconomy
        or {};

    local market =
        economy.market
        or {};

    local companies =
        market.companies
        or {};

    local ourNation =
        (
            economy.nations
            or {}
        )[
            game.Us.ID
        ]
        or {};

    UI.CreateLabel(area)
        .SetText(
            "GLOBAL STOCK MARKET"
        );

    local navigation =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    UI.CreateButton(navigation)
        .SetText(
            "MY PORTFOLIO"
        )
        .SetFlexibleWidth(1)
        .SetOnClick(function()

            ShowStockPortfolio(
                parent,
                game
            );

        end);

    UI.CreateButton(navigation)
        .SetText(
            "MARKET OVERVIEW"
        )
        .SetFlexibleWidth(1)
        .SetOnClick(function()

            ShowMarketOverview(
                parent,
                game
            );

        end);

    UI.CreateLabel(area)
        .SetText(
            "Quick Search"
        );

    local searchInput =
        UI.CreateTextInputField(
            area
        )
            .SetPlaceholderText(
                "Search company, strategy, or owner..."
            );

    local resultsHost =
        UI.CreateVerticalLayoutGroup(
            area
        );

    local resultsGroup =
        nil;

    local function RenderCompanies()

        if resultsGroup ~= nil
            and not UI.IsDestroyed(
                resultsGroup
            )
        then

            UI.Destroy(
                resultsGroup
            );

        end

        resultsGroup =
            UI.CreateVerticalLayoutGroup(
                resultsHost
            );

        local searchText =
            string.lower(
                searchInput.GetText()
                or ""
            );

        local matches =
            {};

        for companyID, company
            in pairs(companies)
        do

            if company.active == true
                and company.delisted ~= true
            then

                local ownerName =
                    "";

                if company.ownerPlayerID ~= nil then
                    ownerName =
                        GetPlayerName(
                            game,
                            company.ownerPlayerID
                        );
                end

                local searchable =
                    string.lower(
                        tostring(
                            company.name
                            or ""
                        ) ..
                        " " ..
                        tostring(
                            company.strategy
                            or ""
                        ) ..
                        " " ..
                        tostring(ownerName)
                    );

                if searchText == ""
                    or string.find(
                        searchable,
                        searchText,
                        1,
                        true
                    ) ~= nil
                then

                    table.insert(
                        matches,
                        {
                            id = companyID,
                            company = company,
                            ownerName = ownerName
                        }
                    );

                end

            end

        end

        table.sort(
            matches,
            function(a, b)

                return string.lower(
                    tostring(
                        a.company.name
                        or ""
                    )
                ) < string.lower(
                    tostring(
                        b.company.name
                        or ""
                    )
                );

            end
        );

        if #matches == 0 then

            UI.CreateLabel(
                resultsGroup
            )
                .SetText(
                    "No listed companies match your search."
                );

            return;
        end

        for _, entry
            in ipairs(matches)
        do

            local companyID =
                entry.id;

            local company =
                entry.company;

            local group =
                UI.CreateVerticalLayoutGroup(
                    resultsGroup
                );

            local currentPrice =
                company.currentPrice
                or company.startingPrice
                or 0;

            local previousPrice =
                company.previousPrice
                or currentPrice;

            local changePercent =
                0;

            if previousPrice > 0 then

                changePercent =
                    (
                        (
                            currentPrice
                            - previousPrice
                        )
                        / previousPrice
                    )
                    * 100;

            end

            local ownedShares =
                (
                    ourNation.stockHoldings
                    or {}
                )[
                    companyID
                ]
                or 0;

            local companyLabel =
                UI.CreateLabel(group)
                    .SetText(
                        tostring(
                            company.name
                            or "Unknown Company"
                        )
                    );

            companyLabel.SetColor(
                "#D4AF37"
            );

            local summaryRow =
                UI.CreateHorizontalLayoutGroup(
                    group
                );

            UI.CreateLabel(summaryRow)
                .SetText(
                    "Price: " ..
                    tostring(currentPrice) ..
                    " | Available: " ..
                    tostring(
                        company.sharesAvailable
                        or 0
                    )
                )
                .SetFlexibleWidth(1);

            local changeLabel =
                UI.CreateLabel(summaryRow)
                    .SetText(
                        string.format(
                            "%+.1f%%",
                            changePercent
                        )
                    );

            if changePercent > 0 then
                changeLabel.SetColor("#32CD32");
            elseif changePercent < 0 then
                changeLabel.SetColor("#FF4C4C");
            end

            local detailsRow =
                UI.CreateHorizontalLayoutGroup(
                    group
                );

            UI.CreateLabel(detailsRow)
                .SetText(
                    "Strategy: " ..
                    tostring(
                        company.strategy
                        or "Unknown"
                    )
                )
                .SetFlexibleWidth(1);

            UI.CreateLabel(detailsRow)
                .SetText(
                    "Your Shares: " ..
                    tostring(ownedShares)
                )
                .SetFlexibleWidth(1);

            if entry.ownerName ~= "" then

                UI.CreateLabel(group)
                    .SetText(
                        "Owner: " ..
                        tostring(
                            entry.ownerName
                        ) ..
                        " | Market Cap: " ..
                        tostring(
                            company.marketCap
                            or 0
                        )
                    );

            end

            UI.CreateButton(group)
                .SetText(
                    "VIEW / TRADE COMPANY"
                )
                .SetOnClick(function()

                    ShowCompanyDetails(
                        parent,
                        game,
                        companyID
                    );

                end);

            UI.CreateLabel(group)
                .SetText(
                    "----------------------------------------"
                );

        end

    end

    searchInput.SetOnValueChanged(function()

        RenderCompanies();

    end);

    RenderCompanies();

end

function ShowCompanyDetails(
    parent,
    game,
    companyID
)

    local area =
        CreateContentArea(
            parent
        );

    local data =
        Mod.PublicGameData
        or {};

    local economy =
        data.globalEconomy
        or {};

    local market =
        economy.market
        or {};

    local company =
        (
            market.companies
            or {}
        )[
            companyID
        ];

    if company == nil then

        UI.CreateLabel(area)
            .SetText(
                "Company not found."
            );

        return;
    end

UI.CreateButton(area)
    .SetText(
        "BACK TO MARKET"
    )
    .SetOnClick(function()

        ShowStockMarket(
            parent,
            game
        );

    end);

    local currentPrice =
        company.currentPrice
        or company.startingPrice
        or 0;

    local previousPrice =
        company.previousPrice
        or currentPrice;

    local changePercent =
        0;

    if previousPrice > 0 then

        changePercent =
            (
                (
                    currentPrice
                    - previousPrice
                )
                / previousPrice
            )
            * 100;

    end

    local companyLabel =
        UI.CreateLabel(area)
            .SetText(
                tostring(
                    company.name
                    or
                    "Unknown Company"
                )
            );

    companyLabel.SetColor(
        "#D4AF37"
    );

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    local statsRow1 =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    UI.CreateLabel(statsRow1)
        .SetText(
            "Price: " ..
            tostring(currentPrice) ..
            " gold"
        )
        .SetFlexibleWidth(1);

    local changeLabel =
        UI.CreateLabel(statsRow1)
            .SetText(
                "Change: " ..
                string.format(
                    "%.1f%%",
                    changePercent
                )
            )
            .SetFlexibleWidth(1);

    if changePercent > 0 then

        changeLabel.SetColor(
            "#32CD32"
        );

    elseif changePercent < 0 then

        changeLabel.SetColor(
            "#FF4C4C"
        );

    end

    local statsRow2 =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    UI.CreateLabel(statsRow2)
        .SetText(
            "Market Cap: " ..
            tostring(
                company.marketCap
                or 0
            )
        )
        .SetFlexibleWidth(1);

    UI.CreateLabel(statsRow2)
        .SetText(
            "Total Shares: " ..
            tostring(
                company.totalShares
                or 0
            )
        )
        .SetFlexibleWidth(1);

    local statsRow3 =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    UI.CreateLabel(statsRow3)
        .SetText(
            "Available: " ..
            tostring(
                company.sharesAvailable
                or 0
            )
        )
        .SetFlexibleWidth(1);

    UI.CreateLabel(statsRow3)
        .SetText(
            "Strategy: " ..
            tostring(
                company.strategy
                or "Unknown"
            )
        )
        .SetFlexibleWidth(1);

    local statsRow4 =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    UI.CreateLabel(statsRow4)
        .SetText(
            "Dividend/Share: " ..
            string.format(
                "%.2f",
                company.dividendPerShare
                or 0
            )
        )
        .SetFlexibleWidth(1);

    UI.CreateLabel(statsRow4)
        .SetText(
            "Dividends Paid: " ..
            tostring(
                company.totalDividendsPaid
                or 0
            )
        )
        .SetFlexibleWidth(1);

-- ============================================
-- TRADE SHARES
-- ============================================

local yourNation =
    (
        economy.nations
        or {}
    )[
        game.Us.ID
    ]
    or {};

local yourShares =
    (
        yourNation.stockHoldings
        or {}
    )[
        companyID
    ]
    or 0;

local availableGold =
    GetPlayerGold(
        game,
        game.Us.ID
    );

UI.CreateLabel(area)
    .SetText(
        "----------------------------------------"
    );

UI.CreateLabel(area)
    .SetText(
        "TRADE SHARES"
    );

UI.CreateLabel(area)
    .SetText(
        "Available Gold: " ..
        tostring(availableGold) ..
        " | Your Shares: " ..
        tostring(yourShares)
    );

local selectedBuyShares =
    1;

local buyPreview =
    UI.CreateLabel(area);

local function UpdateBuyPreview()

    local availableShares =
        company.sharesAvailable
        or 0;

    if availableShares <= 0 then

        selectedBuyShares =
            0;

        buyPreview.SetText(
            "No public shares are currently available."
        );

        return;

    end

    selectedBuyShares =
        math.max(
            1,
            math.min(
                selectedBuyShares,
                availableShares
            )
        );

    buyPreview.SetText(
        "Buy " ..
        tostring(selectedBuyShares) ..
        " share(s) | Cost: " ..
        tostring(
            selectedBuyShares
            * currentPrice
        ) ..
        " gold"
    );

end

local buyButtons =
    UI.CreateHorizontalLayoutGroup(
        area
    );

UI.CreateButton(buyButtons)
    .SetText("-1")
    .SetFlexibleWidth(1)
    .SetOnClick(function()

        selectedBuyShares =
            math.max(
                1,
                selectedBuyShares - 1
            );

        UpdateBuyPreview();

    end);

UI.CreateButton(buyButtons)
    .SetText("+1")
    .SetFlexibleWidth(1)
    .SetOnClick(function()

        selectedBuyShares =
            selectedBuyShares + 1;

        UpdateBuyPreview();

    end);

UI.CreateButton(buyButtons)
    .SetText("+5")
    .SetFlexibleWidth(1)
    .SetOnClick(function()

        selectedBuyShares =
            selectedBuyShares + 5;

        UpdateBuyPreview();

    end);

local buyButton =
    UI.CreateButton(area)
        .SetText(
            "BUY SHARES"
        )
        .SetInteractable(
            (company.sharesAvailable or 0) > 0
        )
        .SetOnClick(function()

            if selectedBuyShares <= 0 then
                return;
            end

            game.SendGameCustomMessage(
                "Buying shares...",
                {
                    type = "buyStock",
                    companyID = companyID,
                    shares = selectedBuyShares
                },
                function(result)

                    if result ~= nil
                        and result.success == true
                    then

                        ShowCompanyDetails(
                            parent,
                            game,
                            companyID
                        );

                    elseif result ~= nil
                        and result.message ~= nil
                    then

                        UI.Alert(
                            tostring(
                                result.message
                            )
                        );

                    end

                end
            );

        end);

UpdateBuyPreview();

local protectedFounderShares =
    0;

if company.founderPlayerID == game.Us.ID then

    protectedFounderShares =
        company.founderShares
        or 0;

end

local sellableShares =
    math.max(
        0,
        yourShares
        - protectedFounderShares
    );

local selectedSellShares =
    sellableShares > 0
    and 1
    or 0;

local sellPreview =
    UI.CreateLabel(area);

local function UpdateSellPreview()

    if sellableShares <= 0 then

        selectedSellShares =
            0;

        sellPreview.SetText(
            "No sellable shares available."
        );

        return;

    end

    selectedSellShares =
        math.max(
            1,
            math.min(
                selectedSellShares,
                sellableShares
            )
        );

    sellPreview.SetText(
        "Sell " ..
        tostring(selectedSellShares) ..
        " share(s) | Value: " ..
        tostring(
            selectedSellShares
            * currentPrice
        ) ..
        " gold"
    );

end

local sellButtons =
    UI.CreateHorizontalLayoutGroup(
        area
    );

UI.CreateButton(sellButtons)
    .SetText("-1")
    .SetFlexibleWidth(1)
    .SetOnClick(function()

        selectedSellShares =
            math.max(
                1,
                selectedSellShares - 1
            );

        UpdateSellPreview();

    end);

UI.CreateButton(sellButtons)
    .SetText("+1")
    .SetFlexibleWidth(1)
    .SetOnClick(function()

        selectedSellShares =
            selectedSellShares + 1;

        UpdateSellPreview();

    end);

UI.CreateButton(sellButtons)
    .SetText("+5")
    .SetFlexibleWidth(1)
    .SetOnClick(function()

        selectedSellShares =
            selectedSellShares + 5;

        UpdateSellPreview();

    end);

UI.CreateButton(area)
    .SetText(
        "SELL SHARES"
    )
    .SetInteractable(
        sellableShares > 0
    )
    .SetOnClick(function()

        if selectedSellShares <= 0 then
            return;
        end

        game.SendGameCustomMessage(
            "Selling shares...",
            {
                type = "sellStock",
                companyID = companyID,
                shares = selectedSellShares
            },
            function(result)

                if result ~= nil
                    and result.success == true
                then

                    ShowCompanyDetails(
                        parent,
                        game,
                        companyID
                    );

                elseif result ~= nil
                    and result.message ~= nil
                then

                    UI.Alert(
                        tostring(
                            result.message
                        )
                    );

                end

            end
        );

    end);

UpdateSellPreview();

UI.CreateLabel(area)
    .SetText(
        "----------------------------------------"
    );

local ownerName =
    "Unknown";

if company.ownerPlayerID ~= nil
    and game.Game ~= nil
    and game.Game.Players ~= nil
    and game.Game.Players[
        company.ownerPlayerID
    ] ~= nil then

    ownerName =
        game.Game.Players[
            company.ownerPlayerID
        ].DisplayName(
            nil,
            false
        );

end

local ownerLabel =
    UI.CreateLabel(area)
        .SetText(
            "Owner Nation: " ..
            tostring(ownerName)
        );

ownerLabel.SetColor(
    "#D4AF37"
);

UI.CreateLabel(area)
    .SetText(
        "SHAREHOLDERS"
    );

local foundShareholder =
    false;

for playerID, nation
    in pairs(
        economy.nations
        or {}
    ) do

    local heldShares =
        (
            nation.stockHoldings
            or {}
        )[
            companyID
        ]
        or 0;

    if heldShares > 0 then

        foundShareholder =
            true;

        local playerName =
            "Unknown";

        if game.Game ~= nil
            and game.Game.Players ~= nil
            and game.Game.Players[
                playerID
            ] ~= nil then

            playerName =
                game.Game.Players[
                    playerID
                ].DisplayName(
                    nil,
                    false
                );

        end

        local ownershipPercent =
            0;

        if (
            company.totalShares
            or 0
        ) > 0 then

            ownershipPercent =
                (
                    heldShares
                    / company.totalShares
                )
                * 100;

        end

        UI.CreateLabel(area)
            .SetText(
                tostring(playerName) ..
                " | " ..
                tostring(heldShares) ..
                " shares | " ..
                string.format(
                    "%.1f%%",
                    ownershipPercent
                )
            );

    end
end

if not foundShareholder then

    UI.CreateLabel(area)
        .SetText(
            "No shareholders recorded."
        );

end

-- ============================================
-- FLAGSHIP OWNER CONTROLS
-- ============================================

if company.ownerPlayerID == game.Us.ID
    or company.founderPlayerID == game.Us.ID
then

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    UI.CreateLabel(area)
        .SetText(
            "FLAGSHIP OWNER CONTROLS"
        );

    UI.CreateLabel(area)
        .SetText(
            "Shares Available: "
            .. tostring(
                company.sharesAvailable
                or 0
            )
        );

    local currentTurn =
        economy.currentEconomyTurn
        or data.tradeTurn
        or 1;

    local lastIssueTurn =
    company.lastShareIssueTurn;

local cooldownRemaining =
    0;

if lastIssueTurn ~= nil then

    cooldownRemaining =
        math.max(
            0,
            5
            - (
                currentTurn
                - lastIssueTurn
            )
        );

end

    if cooldownRemaining > 0 then

        UI.CreateLabel(area)
            .SetText(
                "Share Issuance Cooldown: "
                .. tostring(
                    cooldownRemaining
                )
                .. " turn(s) remaining"
            );

    else

        UI.CreateLabel(area)
            .SetText(
                "Issue New Public Shares"
            );

        local function IssueShares(
            amount
        )

            game.SendGameCustomMessage(
                "Issuing new shares...",
                {
                    type =
                        "issueShares",

                    companyID =
                        companyID,

                    shares =
                        amount
                },
                function(result)

                    if result ~= nil
                        and result.success == true
                    then

                        ShowStockMarket(
                            parent,
                            game
                        );

                    end

                end
            );

        end

        local issueButtons =
            UI.CreateHorizontalLayoutGroup(
                area
            );

        UI.CreateButton(issueButtons)
            .SetText(
                "+10"
            )
            .SetFlexibleWidth(1)
            .SetOnClick(function()

                IssueShares(
                    10
                );

            end);

        UI.CreateButton(issueButtons)
            .SetText(
                "+25"
            )
            .SetFlexibleWidth(1)
            .SetOnClick(function()

                IssueShares(
                    25
                );

            end);

        UI.CreateButton(issueButtons)
            .SetText(
                "+50"
            )
            .SetFlexibleWidth(1)
            .SetOnClick(function()

                IssueShares(
                    50
                );

            end);

        UI.CreateLabel(area)
            .SetText(
                "Issuing shares dilutes existing ownership percentages."
            );

    end

end

UI.CreateLabel(area)
    .SetText(
        "----------------------------------------"
    );

UI.CreateLabel(area)
    .SetText(
        "YOUR POSITION"
    );

local yourCostBasis =
    (
        yourNation.stockCostBasis
        or {}
    )[
        companyID
    ]
    or 0;

local yourPositionValue =
    yourShares
    * currentPrice;
local averageCost =
    0;

if yourShares > 0 then

    averageCost =
        yourCostBasis
        / yourShares;

end
local unrealizedProfit =
    yourPositionValue
    - yourCostBasis;

UI.CreateLabel(area)
    .SetText(
        "Shares Owned: " ..
        tostring(yourShares)
    );

UI.CreateLabel(area)
    .SetText(
        "Position Value: " ..
        tostring(yourPositionValue) ..
        " gold"
    );

UI.CreateLabel(area)
    .SetText(
        "Cost Basis: " ..
        tostring(yourCostBasis) ..
        " gold"
    );
UI.CreateLabel(area)
    .SetText(
        "Average Cost: " ..
        string.format(
            "%.2f",
            averageCost
        ) ..
        " gold/share"
    );

local profitLabel =
    UI.CreateLabel(area)
        .SetText(
            "Unrealized P/L: " ..
            tostring(unrealizedProfit) ..
            " gold"
        );

if unrealizedProfit > 0 then

    profitLabel.SetColor(
        "#32CD32"
    );

elseif unrealizedProfit < 0 then

    profitLabel.SetColor(
        "#FF4C4C"
    );

end

UI.CreateLabel(area)
    .SetText(
        "----------------------------------------"
    );

UI.CreateLabel(area)
    .SetText(
        "PRICE HISTORY"
    );

local history =
    company.priceHistory
    or {};

if #history == 0 then

    UI.CreateLabel(area)
        .SetText(
            "No price history available yet."
        );

else

    local startIndex =
        math.max(
            1,
            #history - 9
        );

    local previousHistoryPrice =
        nil;

    for index = startIndex, #history do

        local entry =
            history[index];

        local historyPrice =
            entry.price
            or 0;

        local historyLabel =
            UI.CreateLabel(area)
                .SetText(
                    "Turn " ..
                    tostring(
                        entry.turn
                        or "?"
                    ) ..
                    " | " ..
                    tostring(
                        historyPrice
                    ) ..
                    " gold"
                );

        if previousHistoryPrice ~= nil then

            if historyPrice > previousHistoryPrice then

                historyLabel.SetColor(
                    "#32CD32"
                );

            elseif historyPrice < previousHistoryPrice then

                historyLabel.SetColor(
                    "#FF4C4C"
                );

            end

        else

            historyLabel.SetColor(
                "#D4AF37"
            );

        end

        previousHistoryPrice =
            historyPrice;

    end

end
local sparkline =
    "";

if #history > 0 then

    local startIndex =
        math.max(
            1,
            #history - 9
        );

    for index = startIndex, #history do

        local entry =
            history[index];

        local historyPrice =
            entry.price
            or 0;

        local previousPrice =
            historyPrice;

        if index > startIndex then

            previousPrice =
                history[
                    index - 1
                ].price
                or historyPrice;

        end

        if historyPrice > previousPrice then

            sparkline =
                sparkline ..
                "▲ ";

        elseif historyPrice < previousPrice then

            sparkline =
                sparkline ..
                "▼ ";

        else

            sparkline =
                sparkline ..
                "● ";

        end

    end

end

local trendGroup =
    UI.CreateHorizontalLayoutGroup(
        area
    );

UI.CreateLabel(trendGroup)
    .SetText(
        "Trend: "
    );

local startIndex =
    math.max(
        1,
        #history - 9
    );

for index = startIndex, #history do

    local entry =
        history[index];

    local historyPrice =
        entry.price
        or 0;

    local symbol =
        "●";

    local symbolColor =
        "#D4AF37";

    if index > startIndex then

        local previousPrice =
            history[
                index - 1
            ].price
            or historyPrice;

        if historyPrice > previousPrice then

            symbol =
                "▲";

            symbolColor =
                "#32CD32";

        elseif historyPrice < previousPrice then

            symbol =
                "▼";

            symbolColor =
                "#FF4C4C";

        end

    end

    local symbolLabel =
        UI.CreateLabel(
            trendGroup
        )
            .SetText(
                symbol
            );

    symbolLabel.SetColor(
        symbolColor
    );

end

end

function ShowStockPortfolio(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    local data =
        Mod.PublicGameData
        or {};

    if data.globalEconomy == nil then

    UI.CreateLabel(area)
        .SetText(
            "Portfolio data is still initializing. Please check again after the economy updates."
        );

    return;

end

    local economy =
        data.globalEconomy
        or {};
    
    if economy.nations == nil
    or economy.market == nil
then

    UI.CreateLabel(area)
        .SetText(
            "Portfolio data is still initializing."
        );

    return;

end

    local nation =
        (
            economy.nations
            or {}
        )[
            game.Us.ID
        ]
        or {};

    local market =
        economy.market
        or {};

    local totalValue =
        0;

    local totalCostBasis =
        0;

    UI.CreateLabel(area)
        .SetText(
            "STOCK PORTFOLIO"
        );

    UI.CreateButton(area)
    .SetText(
        "BACK TO MARKET"
    )
    .SetOnClick(function()

        ShowStockMarket(
            parent,
            game
        );

    end);

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    for companyID, shares
        in pairs(
            nation.stockHoldings
            or {}
        ) do

        if shares > 0 then

            local company =
                (
                    market.companies
                    or {}
                )[
                    companyID
                ];

            if company ~= nil then

                local price =
                    company.currentPrice
                    or company.startingPrice
                    or 0;

                local positionValue =
                    shares
                    * price;

                local costBasis =
                    (
                        nation.stockCostBasis
                        or {}
                    )[
                        companyID
                    ]
                    or 0;

                local profit =
                    positionValue
                    - costBasis;

                totalValue =
                    totalValue
                    + positionValue;

                totalCostBasis =
                    totalCostBasis
                    + costBasis;

                local companyLabel =
                    UI.CreateLabel(area)
                        .SetText(
                            tostring(
                                company.name
                                or
                                "Unknown Company"
                            )
                        );

                companyLabel.SetColor(
                    "#D4AF37"
                );

                UI.CreateLabel(area)
                    .SetText(
                        "Shares: " ..
                        tostring(shares) ..
                        " | Value: " ..
                        tostring(positionValue) ..
                        " commerce"
                    );

                local profitLabel =
                    UI.CreateLabel(area)
                        .SetText(
                            "Unrealized P/L: " ..
                            tostring(profit) ..
                            " commerce"
                        );

                if profit > 0 then

                    profitLabel.SetColor(
                        "#32CD32"
                    );

                elseif profit < 0 then

                    profitLabel.SetColor(
                        "#FF4C4C"
                    );

                end

                UI.CreateLabel(area)
                    .SetText(
                        "----------------------------------------"
                    );

            end
        end
    end

-- =========================================
-- GLOBAL MARKET ETF POSITION
-- =========================================

local etf =
    market.etf
    or {};

local etfShares =
    nation.etfShares
    or 0;

local etfPrice =
    etf.currentPrice
    or etf.startingPrice
    or 100;

local etfValue =
    etfShares
    * etfPrice;

local etfCostBasis =
    nation.etfCostBasis
    or 0;

local etfProfit =
    etfValue
    - etfCostBasis;


if etfShares > 0 then

    UI.CreateLabel(area)
        .SetText(
            "GLOBAL MARKET ETF"
        )
        .SetColor(
            "#D4AF37"
        );

    UI.CreateLabel(area)
        .SetText(
            "Shares: " ..
            tostring(
                etfShares
            ) ..
            " | Value: " ..
            string.format(
                "%.2f",
                etfValue
            ) ..
            " gold"
        );

    local etfProfitLabel =
        UI.CreateLabel(area)
            .SetText(
                "Unrealized P/L: " ..
                string.format(
                    "%.2f",
                    etfProfit
                ) ..
                " gold"
            );

    if etfProfit > 0 then

        etfProfitLabel.SetColor(
            "#32CD32"
        );

    elseif etfProfit < 0 then

        etfProfitLabel.SetColor(
            "#FF4C4C"
        );

    end

    UI.CreateLabel(area)
        .SetText(
            "ETF Dividends Received: " ..
            tostring(
                nation.etfDividendsReceived
                or 0
            ) ..
            " gold"
        );

    UI.CreateLabel(area)
        .SetText(
            "Realized ETF Profit: " ..
            string.format(
                "%.2f",
                nation.realizedETFProfit
                or 0
            ) ..
            " gold"
        );

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

end


-- Include ETF in overall portfolio totals

totalValue =
    totalValue
    + etfValue;

totalCostBasis =
    totalCostBasis
    + etfCostBasis;

    local totalProfit =
        totalValue
        - totalCostBasis;

    UI.CreateLabel(area)
        .SetText(
            "TOTAL PORTFOLIO VALUE: " ..
            tostring(totalValue) ..
            " gold"
        );

    UI.CreateLabel(area)
        .SetText(
            "TOTAL COST BASIS: " ..
            tostring(totalCostBasis) ..
            " gold"
        );

    local totalProfitLabel =
        UI.CreateLabel(area)
            .SetText(
                "TOTAL UNREALIZED P/L: " ..
                tostring(totalProfit) ..
                " gold"
            );

    if totalProfit > 0 then

        totalProfitLabel.SetColor(
            "#32CD32"
        );

    elseif totalProfit < 0 then

        totalProfitLabel.SetColor(
            "#FF4C4C"
        );

    end

    UI.CreateLabel(area)
        .SetText(
            "Realized Profit: " ..
            tostring(
                nation.realizedStockProfit
                or 0
            ) ..
            " gold"
        );

    UI.CreateLabel(area)
        .SetText(
            "Dividends Received: " ..
            tostring(
                nation.dividendsReceived
                or 0
            ) ..
            " gold"
        );

end


function ShowMarketOverview(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    local data =
        Mod.PublicGameData
        or {};

    local economy =
        data.globalEconomy
        or {};

    local market =
        economy.market
        or {};

    local companies =
        market.companies
        or {};

    UI.CreateLabel(area)
        .SetText(
            "MARKET OVERVIEW"
        );

    UI.CreateButton(area)
        .SetText(
            "BACK TO MARKET"
        )
        .SetOnClick(function()

            ShowStockMarket(
                parent,
                game
            );

        end);

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    local topGainer =
        nil;

    local topLoser =
        nil;

    local largestCompany =
        nil;

    local mostTradedCompany =
    nil;

local mostTradedVolume =
    -1;

    local topGainPercent =
        nil;

    local topLossPercent =
        nil;

    for _, company
        in pairs(companies) do

        if company.active == true
            and company.delisted ~= true then

            local currentPrice =
                company.currentPrice
                or company.startingPrice
                or 0;

            local previousPrice =
                company.previousPrice
                or currentPrice;

            local changePercent =
                0;

            if previousPrice > 0 then

                changePercent =
                    (
                        (
                            currentPrice
                            - previousPrice
                        )
                        / previousPrice
                    )
                    * 100;

            end

            if topGainPercent == nil
                or changePercent > topGainPercent then

                topGainPercent =
                    changePercent;

                topGainer =
                    company;

            end

            if topLossPercent == nil
                or changePercent < topLossPercent then

                topLossPercent =
                    changePercent;

                topLoser =
                    company;

            end

            if largestCompany == nil
                or (
                    company.marketCap
                    or 0
                ) > (
                    largestCompany.marketCap
                    or 0
                ) then

                largestCompany =
                    company;

end
            local tradeVolume =
    company.lastTurnVolume
    or 0;

if mostTradedCompany == nil
    or tradeVolume > mostTradedVolume then

    mostTradedVolume =
        tradeVolume;

    mostTradedCompany =
        company;

end
            end
        end

    UI.CreateLabel(area)
        .SetText(
            "MARKET LEADERS"
        );

    if topGainer ~= nil then

        local gainerLabel =
            UI.CreateLabel(area)
                .SetText(
                    "Top Gainer: " ..
                    tostring(
                        topGainer.name
                    ) ..
                    " | +" ..
                    string.format(
                        "%.1f%%",
                        topGainPercent
                    )
                );

        gainerLabel.SetColor(
            "#32CD32"
        );

    end

    if topLoser ~= nil then

        local loserLabel =
            UI.CreateLabel(area)
                .SetText(
                    "Top Loser: " ..
                    tostring(
                        topLoser.name
                    ) ..
                    " | " ..
                    string.format(
                        "%.1f%%",
                        topLossPercent
                    )
                );

        loserLabel.SetColor(
            "#FF4C4C"
        );

    end

    if largestCompany ~= nil then

        local largestLabel =
            UI.CreateLabel(area)
                .SetText(
                    "Largest Market Cap: " ..
                    tostring(
                        largestCompany.name
                    ) ..
                    " | " ..
                    tostring(
                        largestCompany.marketCap
                        or 0
                    ) ..
                    " commerce"
                );

        largestLabel.SetColor(
            "#D4AF37"
        );

    end

if mostTradedCompany ~= nil
    and mostTradedVolume >= 0 then

    local mostTradedLabel =
        UI.CreateLabel(area)
            .SetText(
                "Most Traded: " ..
                tostring(
                    mostTradedCompany.name
                ) ..
                " | " ..
                tostring(
                    mostTradedVolume
                ) ..
                " shares"
            );

    mostTradedLabel.SetColor(
        "#D4AF37"
    );

end
-- =========================================
-- GLOBAL MARKET ETF OVERVIEW
-- =========================================

local etf =
    market.etf
    or {};

local etfPrice =
    etf.currentPrice
    or etf.startingPrice
    or 100;

local etfPreviousPrice =
    etf.previousPrice
    or etfPrice;

local etfChangePercent =
    0;

if etfPreviousPrice > 0 then

    etfChangePercent =
        (
            etfPrice
            - etfPreviousPrice
        )
        / etfPreviousPrice
        * 100;

end


UI.CreateLabel(area)
    .SetText(
        "----------------------------------------"
    );

local etfTitle =
    UI.CreateLabel(area)
        .SetText(
            "GLOBAL MARKET ETF"
        );

etfTitle.SetColor(
    "#D4AF37"
);


UI.CreateLabel(area)
    .SetText(
        "Price: " ..
        string.format(
            "%.2f",
            etfPrice
        ) ..
        " Commerce"
    );


local etfChangeLabel =
    UI.CreateLabel(area)
        .SetText(
            "Turn Change: " ..
            string.format(
                "%.2f%%",
                etfChangePercent
            )
        );

if etfChangePercent > 0 then

    etfChangeLabel.SetColor(
        "#32CD32"
    );

elseif etfChangePercent < 0 then

    etfChangeLabel.SetColor(
        "#FF4C4C"
    );

end


UI.CreateLabel(area)
    .SetText(
        "ETF Members: " ..
        tostring(
            #(
                etf.memberCompanyIDs
                or {}
            )
        )
    );

end

function ShowMarketNews(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    local data =
        Mod.PublicGameData
        or {};

    local economy =
        data.globalEconomy
        or {};

    local market =
        economy.market
        or {};

    local news =
        market.news
        or {};

    UI.CreateLabel(area)
        .SetText(
            "MARKET NEWS"
        );

    UI.CreateButton(area)
        .SetText(
            "BACK TO MARKET"
        )
        .SetOnClick(function()

            ShowStockMarket(
                parent,
                game
            );

        end);

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    if #news == 0 then

        UI.CreateLabel(area)
            .SetText(
                "No major market news yet."
            );

        return;
    end

    local startIndex =
        math.max(
            1,
            #news - 14
        );

    for index = #news, startIndex, -1 do

        local entry =
            news[index];

        local headline =
            UI.CreateLabel(area)
                .SetText(
                    "Turn " ..
                    tostring(
                        entry.turn
                        or "?"
                    ) ..
                    " | " ..
                    tostring(
                        entry.message
                        or
                        "Market update."
                    )
                );

        if entry.type == "stock_split" then

            headline.SetColor(
                "#D4AF37"
            );

        elseif entry.type == "dividend" then

            headline.SetColor(
                "#32CD32"
            );

        elseif entry.type == "etf_rebalance" then

    headline.SetColor(
        "#D4AF37"
    );

elseif entry.type == "etf_dividend" then

    headline.SetColor(
        "#32CD32"
    );

        elseif entry.type == "major_move" then

            local message =
                string.lower(
                    tostring(
                        entry.message
                        or ""
                    )
                );

            if string.find(
                message,
                "fell"
            ) then

                headline.SetColor(
                    "#FF4C4C"
                );

            else

                headline.SetColor(
                    "#32CD32"
                );

            end

        end

    end

end

function ShowMarketETF(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    local data =
        Mod.PublicGameData
        or {};

    local economy =
        data.globalEconomy
        or {};

    local market =
        economy.market
        or {};

    local etf =
        market.etf
        or {};

    local nation =
        (
            economy.nations
            and economy.nations[
                game.Us.ID
            ]
        )
        or {};


    -- =========================================
    -- HEADER
    -- =========================================

    UI.CreateLabel(area)
        .SetText(
            etf.name
            or "GLOBAL MARKET ETF"
        )
        .SetColor(
            "#D4AF37"
        );

    UI.CreateButton(area)
        .SetText(
            "BACK TO MARKETS"
        )
        .SetOnClick(function()

            ShowMarketsMenu(
                parent,
                game
            );

        end);

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =========================================
    -- ETF PRICE
    -- =========================================

    local currentPrice =
        etf.currentPrice
        or 100;

    local previousPrice =
        etf.previousPrice
        or currentPrice;

    local changePercent =
        0;

    if previousPrice > 0 then

        changePercent =
            (
                currentPrice
                - previousPrice
            )
            / previousPrice
            * 100;

    end

    UI.CreateLabel(area)
        .SetText(
            "ETF Price: " ..
            string.format(
                "%.2f",
                currentPrice
            ) ..
            " Commerce"
        );

    local changeLabel =
        UI.CreateLabel(area)
            .SetText(
                "Turn Change: " ..
                string.format(
                    "%.2f%%",
                    changePercent
                )
            );

    if changePercent > 0 then

        changeLabel.SetColor(
            "#32CD32"
        );

    elseif changePercent < 0 then

        changeLabel.SetColor(
            "#FF4C4C"
        );

    end

    UI.CreateLabel(area)
        .SetText(
            "Shares Available: " ..
            tostring(
                etf.sharesAvailable
                or 0
            )
        );

    UI.CreateLabel(area)
    .SetText(
        "Dividend / Share: " ..
        string.format(
            "%.2f",
            etf.dividendPerShare
            or 0
        ) ..
        " Commerce"
    );

UI.CreateLabel(area)
    .SetText(
        "Total ETF Dividends Paid: " ..
        tostring(
            etf.totalDividendsPaid
            or 0
        ) ..
        " Commerce"
    );

    -- =========================================
    -- ETF MEMBERS
    -- =========================================

    UI.CreateLabel(area)
        .SetText(
            ""
        );

    UI.CreateLabel(area)
        .SetText(
            "TOP 5 ETF COMPANIES"
        )
        .SetColor(
            "#D4AF37"
        );

    local memberIDs =
        etf.memberCompanyIDs
        or {};

    if #memberIDs == 0 then

        UI.CreateLabel(area)
            .SetText(
                "ETF members will be selected after market processing."
            );

    else

        for index,companyID in ipairs(
            memberIDs
        ) do

            local company =
                market.companies
                and market.companies[
                    companyID
                ];

            if company ~= nil then

                local companyName =
                    company.name
                    or (
                        "Company " ..
                        tostring(
                            companyID
                        )
                    );

                local companyPrice =
                    company.currentPrice
                    or company.startingPrice
                    or 1;

                UI.CreateLabel(area)
                    .SetText(
                        tostring(index) ..
                        ". " ..
                        tostring(companyName) ..
                        " | " ..
                        string.format(
                            "%.2f",
                            companyPrice
                        ) ..
                        " Commerce"
                    )
                    .SetColor(
                        "#D4AF37"
                    );

            end

        end

    end


    -- =========================================
    -- PLAYER ETF POSITION
    -- =========================================

    UI.CreateLabel(area)
        .SetText(
            ""
        );

    UI.CreateLabel(area)
        .SetText(
            "YOUR ETF POSITION"
        );

    local ownedShares =
        nation.etfShares
        or 0;

    local costBasis =
        nation.etfCostBasis
        or 0;

    local positionValue =
        ownedShares
        * currentPrice;

    local unrealizedProfit =
        positionValue
        - costBasis;

    UI.CreateLabel(area)
        .SetText(
            "Shares Owned: " ..
            tostring(
                ownedShares
            )
        );

    UI.CreateLabel(area)
        .SetText(
            "Position Value: " ..
            string.format(
                "%.2f",
                positionValue
            ) ..
            " Commerce"
        );

    UI.CreateLabel(area)
        .SetText(
            "Cost Basis: " ..
            string.format(
                "%.2f",
                costBasis
            ) ..
            " Commerce"
        );

    UI.CreateLabel(area)
    .SetText(
        "ETF Dividends Received: " ..
        tostring(
            nation.etfDividendsReceived
            or 0
        ) ..
        " Commerce"
    );

UI.CreateLabel(area)
    .SetText(
        "Realized ETF Profit: " ..
        string.format(
            "%.2f",
            nation.realizedETFProfit
            or 0
        ) ..
        " Commerce"
    );

    local profitLabel =
        UI.CreateLabel(area)
            .SetText(
                "Unrealized P/L: " ..
                string.format(
                    "%.2f",
                    unrealizedProfit
                ) ..
                " Commerce"
            );

    if unrealizedProfit > 0 then

        profitLabel.SetColor(
            "#32CD32"
        );

    elseif unrealizedProfit < 0 then

        profitLabel.SetColor(
            "#FF4C4C"
        );

    end
-- =========================================
-- BUY ETF
-- =========================================

local buyShares =
    1;

local buyPreview =
    UI.CreateLabel(area);

local function UpdateBuyPreview()

    if buyShares < 1 then
        buyShares = 1;
    end

    local availableShares =
        etf.sharesAvailable
        or 0;

    if availableShares > 0
        and buyShares > availableShares then

        buyShares =
            availableShares;
    end

    local totalCost =
        buyShares
        * currentPrice;

    buyPreview.SetText(
        "Buy " ..
        tostring(buyShares) ..
        " share(s) | Cost: " ..
        string.format(
            "%.2f",
            totalCost
        ) ..
        " Commerce"
    );

end


UI.CreateButton(area)
    .SetText("-1")
    .SetOnClick(function()

        buyShares =
            math.max(
                1,
                buyShares - 1
            );

        UpdateBuyPreview();

    end);


UI.CreateButton(area)
    .SetText("+1")
    .SetOnClick(function()

        buyShares =
            buyShares + 1;

        UpdateBuyPreview();

    end);


UI.CreateButton(area)
    .SetText("+5")
    .SetOnClick(function()

        buyShares =
            buyShares + 5;

        UpdateBuyPreview();

    end);


UI.CreateButton(area)
    .SetText("BUY ETF")
    .SetOnClick(function()

        if buyShares <= 0 then
            return;
        end

        game.SendGameCustomMessage(
            "Buy ETF",
            {
                type =
                    "buyETF",

                shares =
                    buyShares
            },
            function()

                ShowMarketETF(
                    parent,
                    game
                );

            end
        );

    end);


UpdateBuyPreview();


-- =========================================
-- SELL ETF
-- =========================================

local sellShares =
    1;

local sellPreview =
    UI.CreateLabel(area);

local function UpdateSellPreview()

    if ownedShares <= 0 then

        sellShares =
            0;

    elseif sellShares > ownedShares then

        sellShares =
            ownedShares;

    elseif sellShares < 1 then

        sellShares =
            1;

    end

    local totalValue =
        sellShares
        * currentPrice;

    sellPreview.SetText(
        "Sell " ..
        tostring(sellShares) ..
        " share(s) | Value: " ..
        string.format(
            "%.2f",
            totalValue
        ) ..
        " Commerce"
    );

end


UI.CreateButton(area)
    .SetText("-1")
    .SetOnClick(function()

        sellShares =
            sellShares - 1;

        UpdateSellPreview();

    end);


UI.CreateButton(area)
    .SetText("+1")
    .SetOnClick(function()

        sellShares =
            sellShares + 1;

        UpdateSellPreview();

    end);


UI.CreateButton(area)
    .SetText("+5")
    .SetOnClick(function()

        sellShares =
            sellShares + 5;

        UpdateSellPreview();

    end);


UI.CreateButton(area)
    .SetText("SELL ETF")
    .SetOnClick(function()

        if sellShares <= 0 then
            return;
        end

        game.SendGameCustomMessage(
            "Sell ETF",
            {
                type =
                    "sellETF",

                shares =
                    sellShares
            },
            function()

                ShowMarketETF(
                    parent,
                    game
                );

            end
        );

    end);


UpdateSellPreview();

end

function ShowInvestments(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    UI.CreateLabel(area)
        .SetText(
            "INVESTMENTS"
        );


    UI.CreateLabel(area)
        .SetText(
            "Create multinational development projects, invest in other nations, and track project outcomes."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    local nav =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(nav)
        .SetText(
            "Project Catalog"
        )
        .SetOnClick(function()


            ShowInvestmentCatalog(
                parent,
                game
            );

        end);


    UI.CreateButton(nav)
        .SetText(
            "Open Projects"
        )
        .SetOnClick(function()


            ShowOpenInvestmentProjects(
                parent,
                game
            );

        end);


    UI.CreateButton(nav)
        .SetText(
            "My Projects"
        )
        .SetOnClick(function()


            ShowMyInvestmentProjects(
                parent,
                game
            );

        end);


    UI.CreateButton(nav)
        .SetText(
            "My Investments"
        )
        .SetOnClick(function()


            ShowMyInvestments(
                parent,
                game
            );

        end);


    UI.CreateButton(nav)
        .SetText(
            "Archive"
        )
        .SetOnClick(function()


            ShowInvestmentArchive(
                parent,
                game
            );

        end);


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    local data =
        Mod.PublicGameData or {};


    local openCount = 0;
    local activeCount = 0;


    for _, project
        in pairs(
            data.investmentProjects
            or {}
        ) do


        if project.status
            == "funding" then


            openCount =
                openCount + 1;


        elseif project.status
            == "active" then


            activeCount =
                activeCount + 1;

        end

    end


    UI.CreateLabel(area)
        .SetText(
            "Open Funding Projects: " ..
            tostring(
                openCount
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Projects in Development: " ..
            tostring(
                activeCount
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Archived Projects: " ..
            tostring(
                #(
                    data.completedInvestmentProjects
                    or {}
                )
            )
        );

end


function FindInvestmentType(
    typeID
)

    for _, projectType
        in ipairs(
            InvestmentProjectTypes
        ) do


        if projectType.id
            == typeID then


            return projectType;

        end

    end


    return nil;

end


function ShowInvestmentCatalog(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    UI.CreateLabel(area)
        .SetText(
            "INVESTMENT PROJECT CATALOG"
        );


    UI.CreateLabel(area)
        .SetText(
            "Select a project category to review its funding size, duration, risk, and possible outcome."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    for _, projectType
        in ipairs(
            InvestmentProjectTypes
        ) do


        local typeID =
            projectType.id;


        local group =
            UI.CreateVerticalLayoutGroup(
                area
            );


        UI.CreateLabel(group)
            .SetText(
                projectType.name
            );


        UI.CreateLabel(group)
            .SetText(
                "Maximum Funding Goal: " ..
                tostring(
                    projectType.maxGoal
                ) ..
                " gold"
            );


        UI.CreateLabel(group)
            .SetText(
                "Development Duration: " ..
                tostring(
                    projectType.duration
                ) ..
                " turns"
            );


        UI.CreateLabel(group)
            .SetText(
                "Success Chance: " ..
                tostring(
                    projectType.successChance
                ) ..
                "%"
            );


        UI.CreateLabel(group)
            .SetText(
                "Success Return: +" ..
                tostring(
                    projectType.successReturn
                ) ..
                "%"
            );


        UI.CreateLabel(group)
            .SetText(
                "Failure Recovery: " ..
                tostring(
                    projectType.failureRecovery
                ) ..
                "%"
            );


        UI.CreateLabel(group)
            .SetText(
                "Risk: " ..
                tostring(
                    projectType.risk
                )
            );


        UI.CreateButton(group)
            .SetText(
                "CREATE " ..
                string.upper(
                    projectType.name
                )
            )
            .SetOnClick(function()


                ShowCreateInvestmentProject(
                    parent,
                    game,
                    typeID
                );

            end);


        UI.CreateLabel(group)
            .SetText(
                "----------------------------------------"
            );

    end

end


function ShowCreateInvestmentProject(
    parent,
    game,
    projectTypeID
)

    local area =
        CreateContentArea(
            parent
        );


    local projectType =
        FindInvestmentType(
            projectTypeID
        );


    if projectType == nil then


        UI.CreateLabel(area)
            .SetText(
                "Investment project type could not be found."
            );


        return;

    end


    local fundingGoal =
        math.min(
            500,
            projectType.maxGoal
        );


    if fundingGoal < 200 then

        fundingGoal =
            200;

    end


    local creatorContribution =
        math.ceil(
            fundingGoal
            * 0.20
        );


    local investorLimit =
        4;
local availableGold =
    GetPlayerGold(
        game,
        game.Us.ID
    );

local goldLabel =
    UI.CreateLabel(area);

    UI.CreateLabel(area)
        .SetText(
            "CREATE " ..
            string.upper(
                projectType.name
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Risk: " ..
            tostring(
                projectType.risk
            ) ..
            " | Success: " ..
            tostring(
                projectType.successChance
            ) ..
            "% | Return: +" ..
            tostring(
                projectType.successReturn
            ) ..
            "%"
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    local preview =
        UI.CreateLabel(area);


    local function UpdatePreview()


        local minimumContribution =
            math.ceil(
                fundingGoal
                * 0.20
            );


        if creatorContribution
            < minimumContribution then


            creatorContribution =
                minimumContribution;

        end


        if creatorContribution
            > fundingGoal then


            creatorContribution =
                fundingGoal;

        end
local remainingGold =
    availableGold
    - creatorContribution;

if remainingGold < 0 then
    remainingGold = 0;
end

goldLabel.SetText(
    "Available Gold: " ..
    tostring(availableGold) ..
    "\nCommitted Gold: " ..
    tostring(creatorContribution) ..
    "\nRemaining Gold: " ..
    tostring(remainingGold)
);

        if fundingGoal < 200 then

            fundingGoal =
                200;

        end


        if fundingGoal
            > projectType.maxGoal then


            fundingGoal =
                projectType.maxGoal;

        end


        preview.SetText(
            "Funding Goal: " ..
            tostring(
                fundingGoal
            ) ..
            " gold\n" ..

            "Your Contribution: " ..
            tostring(
                creatorContribution
            ) ..
            " gold\n" ..

            "Minimum Required: " ..
            tostring(
                math.ceil(
                    fundingGoal
                    * 0.20
                )
            ) ..
            " gold\n" ..

            "Outside Investor Limit: " ..
            tostring(
                investorLimit
            )
        );

    end


    UpdatePreview();


    UI.CreateLabel(area)
        .SetText(
            "FUNDING GOAL"
        );


    local fundingButtons =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(fundingButtons)
        .SetText(
            "-100"
        )
        .SetOnClick(function()


            fundingGoal =
                math.max(
                    200,
                    fundingGoal - 100
                );


            UpdatePreview();

        end);


    UI.CreateButton(fundingButtons)
        .SetText(
            "+100"
        )
        .SetOnClick(function()


            fundingGoal =
                math.min(
                    projectType.maxGoal,
                    fundingGoal + 100
                );


            UpdatePreview();

        end);


    UI.CreateButton(fundingButtons)
        .SetText(
            "MAX"
        )
        .SetOnClick(function()


            fundingGoal =
                projectType.maxGoal;


            UpdatePreview();

        end);


    UI.CreateLabel(area)
        .SetText(
            "YOUR CONTRIBUTION"
        );


    local contributionButtons =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(contributionButtons)
        .SetText(
            "-100"
        )
        .SetOnClick(function()


            creatorContribution =
                creatorContribution
                - 100;


            UpdatePreview();

        end);


    UI.CreateButton(contributionButtons)
        .SetText(
            "+100"
        )
        .SetOnClick(function()


            creatorContribution =
                creatorContribution
                + 100;


            UpdatePreview();

        end);


    UI.CreateButton(contributionButtons)
        .SetText(
            "MIN"
        )
        .SetOnClick(function()


            creatorContribution =
                math.ceil(
                    fundingGoal
                    * 0.20
                );


            UpdatePreview();

        end);


    UI.CreateButton(contributionButtons)
        .SetText(
            "FULL"
        )
        .SetOnClick(function()


            creatorContribution =
                fundingGoal;


            UpdatePreview();

        end);


    UI.CreateLabel(area)
        .SetText(
            "OUTSIDE INVESTOR LIMIT"
        );


    local investorButtons =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(investorButtons)
        .SetText(
            "-"
        )
        .SetOnClick(function()


            investorLimit =
                math.max(
                    2,
                    investorLimit - 1
                );


            UpdatePreview();

        end);


    UI.CreateButton(investorButtons)
        .SetText(
            "+"
        )
        .SetOnClick(function()


            investorLimit =
                math.min(
                    6,
                    investorLimit + 1
                );


            UpdatePreview();

        end);


    UI.CreateButton(area)
        .SetText(
            "PUBLISH PROJECT"
        )
        .SetOnClick(function()

            local currentGold =
    GetPlayerGold(
        game,
        game.Us.ID
    );

if creatorContribution > currentGold then

    UI.Alert(
        "You do not have enough gold for this contribution.\n\n" ..
        "Available Gold: " ..
        tostring(currentGold) ..
        "\nRequired Gold: " ..
        tostring(creatorContribution)
    );

    return;
end

            game.SendGameCustomMessage(
                "Publishing project...",

                {

                    type =
                        "publishInvestmentProject",

                    projectTypeID =
                        projectType.id,

                    fundingGoal =
                        fundingGoal,

                    creatorContribution =
                        creatorContribution,

                    investorLimit =
                        investorLimit

                },

                function(result)


                    UI.Alert(
                        result
                        and result.message
                        or
                        "Project request processed."
                    );


                    if result ~= nil
                        and result.success then


                        ShowMyInvestmentProjects(
                            parent,
                            game
                        );

                    end

                end
            );

        end);


    UI.CreateButton(area)
        .SetText(
            "Back"
        )
        .SetOnClick(function()


            ShowInvestmentCatalog(
                parent,
                game
            );

        end);

end
function ShowOpenInvestmentProjects(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    UI.CreateLabel(area)
        .SetText(
            "OPEN INVESTMENT PROJECTS"
        );


    local found =
        false;


    for _, project
        in pairs(
            data.investmentProjects
            or {}
        ) do


        if project.status
            == "funding" then


            found =
                true;


            local selectedID =
                project.id;


            local creatorName =
                GetPlayerName(
                    game,
                    project.creatorID
                );


            local remaining =
                project.fundingGoal
                - project.currentFunding;


            local group =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            UI.CreateLabel(group)
                .SetText(
                    project.projectName
                );


            UI.CreateLabel(group)
                .SetText(
                    "Creator: " ..
                    creatorName
                );


            if project.createdByAI then


                UI.CreateLabel(group)
                    .SetText(
                        "Creator Type: AI Nation"
                    );
            end


            UI.CreateLabel(group)
                .SetText(
                    "Risk: " ..
                    tostring(
                        project.risk
                    ) ..
                    " | Success: " ..
                    tostring(
                        project.successChance
                    ) ..
                    "%"
                );


            UI.CreateLabel(group)
                .SetText(
                    "Funding: " ..
                    tostring(
                        project.currentFunding
                    ) ..
                    " / " ..
                    tostring(
                        project.fundingGoal
                    )
                );


            UI.CreateLabel(group)
                .SetText(
                    "Remaining: " ..
                    tostring(
                        remaining
                    ) ..
                    " gold"
                );


            UI.CreateLabel(group)
                .SetText(
                    "Outside Investors: " ..
                    tostring(
                        CountOutsideProjectInvestors(
                            project
                        )
                    ) ..
                    " / " ..
                    tostring(
                        project.investorLimit
                    )
                );


            if project.creatorID
                ~= game.Us.ID then


                local alreadyInvested =
                    GetOurProjectInvestment(
                        project,
                        game
                    );


                local cap =
                    math.floor(
                        project.fundingGoal
                        * 0.25
                    );


                local remainingCap =
                    math.max(
                        0,
                        cap
                        - alreadyInvested
                    );


                UI.CreateLabel(group)
                    .SetText(
                        "You Invested: " ..
                        tostring(
                            alreadyInvested
                        )
                    );


                UI.CreateLabel(group)
                    .SetText(
                        "Your Remaining Cap: " ..
                        tostring(
                            remainingCap
                        )
                    );


                local maximum =
                    math.min(
                        remaining,
                        remainingCap
                    );


                if maximum > 0 then


                    local amount =
                        math.min(
                            50,
                            maximum
                        );


                    local amountLabel =
                        UI.CreateLabel(group);
                    
                    local availableGold =
    GetPlayerGold(
        game,
        game.Us.ID
    );

local goldLabel =
    UI.CreateLabel(group);

                    local function UpdateAmount()


local remainingGold =
    availableGold
    - amount;

if remainingGold < 0 then
    remainingGold = 0;
end

amountLabel.SetText(
    "Investment Amount: " ..
    tostring(amount)
);

goldLabel.SetText(
    "Available Gold: " ..
    tostring(availableGold) ..
    "\nCommitted Gold: " ..
    tostring(amount) ..
    "\nRemaining Gold: " ..
    tostring(remainingGold)
);

end
                    UpdateAmount();


                    local buttons =
                        UI.CreateHorizontalLayoutGroup(
                            group
                        );


                    UI.CreateButton(buttons)
                        .SetText("-50")
                        .SetOnClick(function()


                            amount =
                                math.max(
                                    1,
                                    amount - 50
                                );


                            UpdateAmount();

                        end);


                    UI.CreateButton(buttons)
                        .SetText("+50")
                        .SetOnClick(function()


                            amount =
                                math.min(
                                    maximum,
                                    amount + 50
                                );


                            UpdateAmount();

                        end);


                    UI.CreateButton(buttons)
                        .SetText("MAX")
                        .SetOnClick(function()


                            amount =
                                maximum;


                            UpdateAmount();

                        end);


                    UI.CreateButton(group)
                        .SetText(
                            "INVEST GOLD"
                        )
                        .SetOnClick(function()

local currentGold =
    GetPlayerGold(
        game,
        game.Us.ID
    );

if amount > currentGold then

    UI.Alert(
        "You do not have enough gold for this investment.\n\n" ..
        "Available Gold: " ..
        tostring(currentGold) ..
        "\nRequired Gold: " ..
        tostring(amount)
    );

    return;
end

                            game.SendGameCustomMessage(
                                "Investing...",

                                {
                                    type =
                                        "investInProject",

                                    projectID =
                                        selectedID,

                                    amount =
                                        amount
                                },

                                function(result)


                                    UI.Alert(
                                        result
                                        and result.message
                                        or
                                        "Investment processed."
                                    );


                                    ShowOpenInvestmentProjects(
                                        parent,
                                        game
                                    );

                                end
                            );

                        end);
                end


            else


                UI.CreateLabel(group)
                    .SetText(
                        "This is your project."
                    );
            end


            UI.CreateLabel(group)
                .SetText(
                    "----------------------------------------"
                );
        end
    end


    if not found then


        UI.CreateLabel(area)
            .SetText(
                "There are no projects currently accepting funding."
            );
    end
end


-- =========================================================
-- MY INVESTMENTS
-- =========================================================

function ShowMyInvestments(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    UI.CreateLabel(area)
        .SetText(
            "MY INVESTMENTS"
        );

        local pendingActions =
    data.pendingInvestmentActions
    or {};

local pendingFound =
    false;

for _, action
    in pairs(pendingActions) do

    if action.type == "invest"
        and action.playerID == game.Us.ID then

        pendingFound =
            true;

        local pendingProject =
            nil;

        for _, project
            in pairs(
                data.investmentProjects
                or {}
            ) do

            if project.id
                == action.projectID then

                pendingProject =
                    project;

                break;
            end
        end

        local projectName =
            "Unknown Project";

        if pendingProject ~= nil then

            projectName =
                pendingProject.projectName
                or projectName;

        end

        local selectedProjectID =
            action.projectID;

        UI.CreateLabel(area)
            .SetText(
                "PENDING: " ..
                tostring(projectName) ..
                " | " ..
                tostring(
                    action.amount
                    or 0
                ) ..
                " gold"
            );

        UI.CreateButton(area)
            .SetText(
                "CANCEL PENDING INVESTMENT"
            )
            .SetOnClick(function()

                game.SendGameCustomMessage(
                    "Cancelling investment...",

                    {
                        type =
                            "cancelPendingInvestment",

                        projectID =
                            selectedProjectID
                    },

                    function(result)

                        UI.Alert(
                            result
                            and result.message
                            or
                            "Cancellation processed."
                        );

                        ShowMyInvestments(
                            parent,
                            game
                        );

                    end
                );

            end);

    end
end

if pendingFound then

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

end

    local found =
        false;


    for _, project
        in pairs(
            data.investmentProjects
            or {}
        ) do


        if project.creatorID
            ~= game.Us.ID then


            local amount =
                GetOurProjectInvestment(
                    project,
                    game
                );


            if amount > 0 then


                found =
                    true;


                UI.CreateLabel(area)
                    .SetText(
                        project.projectName ..
                        " | Invested: " ..
                        tostring(
                            amount
                        ) ..
                        " | Status: " ..
                        tostring(
                            project.status
                        )
                    );


                if project.status
                    == "active"

                    and project.completionTurn
                    ~= nil then


                    local remaining =
                        project.completionTurn
                        - (
                            data.tradeTurn
                            or 0
                        );


                    UI.CreateLabel(area)
                        .SetText(
                            "Completion in " ..
                            tostring(
                                math.max(
                                    0,
                                    remaining
                                )
                            ) ..
                            " turn(s)"
                        );
                end
            end
        end
    end


    if not found then


        UI.CreateLabel(area)
            .SetText(
                "You currently have no active outside investments."
            );
    end


    UI.CreateLabel(area)
        .SetText(
            "Completed investments can be reviewed in the Archive."
        );
end


-- =========================================================
-- MY PROJECTS
-- =========================================================

function ShowMyInvestmentProjects(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    UI.CreateLabel(area)
        .SetText(
            "MY PROJECTS"
        );


    local found =
        false;


    for _, project
        in pairs(
            data.investmentProjects
            or {}
        ) do


        if project.creatorID
            == game.Us.ID then


            found =
                true;


            local group =
                UI.CreateVerticalLayoutGroup(
                    area
                );


            UI.CreateLabel(group)
                .SetText(
                    project.projectName
                );


            UI.CreateLabel(group)
                .SetText(
                    "Status: " ..
                    tostring(
                        project.status
                    )
                );


            UI.CreateLabel(group)
                .SetText(
                    "Funding: " ..
                    tostring(
                        project.currentFunding
                    ) ..
                    " / " ..
                    tostring(
                        project.fundingGoal
                    )
                );


            UI.CreateLabel(group)
                .SetText(
                    "Your Contribution: " ..
                    tostring(
                        project.creatorContribution
                    )
                );


            UI.CreateLabel(group)
                .SetText(
                    "Outside Investors: " ..
                    tostring(
                        CountOutsideProjectInvestors(
                            project
                        )
                    ) ..
                    " / " ..
                    tostring(
                        project.investorLimit
                    )
                );


            if project.status
                == "funding"

                and project.fundingDeadline
                ~= nil then


                UI.CreateLabel(group)
                    .SetText(
                        "Funding Window: " ..
                        tostring(
                            math.max(
                                0,
                                project.fundingDeadline
                                - (
                                    data.tradeTurn
                                    or 0
                                )
                            )
                        ) ..
                        " turn(s)"
                    );
            end


            if project.status
                == "active"

                and project.completionTurn
                ~= nil then


                UI.CreateLabel(group)
                    .SetText(
                        "Completion: " ..
                        tostring(
                            math.max(
                                0,
                                project.completionTurn
                                - (
                                    data.tradeTurn
                                    or 0
                                )
                            )
                        ) ..
                        " turn(s)"
                    );
            end


            UI.CreateLabel(group)
                .SetText(
                    "----------------------------------------"
                );
        end
    end


    if not found then


        UI.CreateLabel(area)
            .SetText(
                "You do not currently have an active project."
            );
    end


    UI.CreateLabel(area)
        .SetText(
            "Finished projects remain permanently available in the Archive."
        );
end


-- =========================================================
-- INVESTMENT ARCHIVE
-- =========================================================
function ShowInvestmentArchive(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    local archive =
        data.completedInvestmentProjects
        or {};


    UI.CreateLabel(area)
        .SetText(
            "COMPLETED PROJECT ARCHIVE"
        );


    UI.CreateLabel(area)
        .SetText(
            "Finished, failed, and expired projects remain recorded here."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    if #archive == 0 then


        UI.CreateLabel(area)
            .SetText(
                "No projects have been archived yet."
            );


        return;
    end


    for i =
        #archive,
        1,
        -1 do


        local project =
            archive[i];


        local selectedProject =
            project;


        local creator =
            GetPlayerName(
                game,
                project.creatorID
            );


        local resultText =
            tostring(
                project.result
                or project.status
                or "Unknown"
            );


        UI.CreateLabel(area)
            .SetText(
                tostring(
                    project.projectName
                ) ..
                " | " ..
                creator ..
                " | Result: " ..
                string.upper(
                    resultText
                )
            );


        UI.CreateButton(area)
            .SetText(
                "View Project #" ..
                tostring(
                    project.id
                )
            )
            .SetOnClick(function()

                ShowArchivedProjectDetails(
                    parent,
                    game,
                    selectedProject
                );

            end);


        UI.CreateLabel(area)
            .SetText(
                "----------------------------------------"
            );
    end
end


function ShowArchivedProjectDetails(
    parent,
    game,
    project
)

    local area =
        CreateContentArea(
            parent
        );


    UI.CreateLabel(area)
        .SetText(
            "PROJECT ARCHIVE DETAILS"
        );


    UI.CreateLabel(area)
        .SetText(
            tostring(
                project.projectName
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Creator: " ..
            GetPlayerName(
                game,
                project.creatorID
            )
        );


    if project.createdByAI then


        UI.CreateLabel(area)
            .SetText(
                "Created By: AI Nation"
            );
    else


        UI.CreateLabel(area)
            .SetText(
                "Created By: Human Nation"
            );
    end


    UI.CreateLabel(area)
        .SetText(
            "Result: " ..
            string.upper(
                tostring(
                    project.result
                    or project.status
                    or "Unknown"
                )
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Funding Goal: " ..
            tostring(
                project.fundingGoal
                or 0
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Final Funding: " ..
            tostring(
                project.currentFunding
                or 0
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Risk: " ..
            tostring(
                project.risk
                or "Unknown"
            )
        );


    UI.CreateLabel(area)
        .SetText(
            "Success Chance: " ..
            tostring(
                project.successChance
                or 0
            ) ..
            "%"
        );


    UI.CreateLabel(area)
        .SetText(
            "Success Return: +" ..
            tostring(
                project.successReturn
                or 0
            ) ..
            "%"
        );


    UI.CreateLabel(area)
        .SetText(
            "Failure Recovery: " ..
            tostring(
                project.failureRecovery
                or 0
            ) ..
            "%"
        );


    UI.CreateLabel(area)
        .SetText(
            "Created Turn: " ..
            tostring(
                project.createdTurn
                or "?"
            )
        );


    if project.startedTurn
        ~= nil then


        UI.CreateLabel(area)
            .SetText(
                "Development Started: Turn " ..
                tostring(
                    project.startedTurn
                )
            );
    end


    UI.CreateLabel(area)
        .SetText(
            "Ended Turn: " ..
            tostring(
                project.endedTurn
                or "?"
            )
        );


    if project.resolutionRoll
        ~= nil then


        UI.CreateLabel(area)
            .SetText(
                "Resolution Roll: " ..
                tostring(
                    project.resolutionRoll
                ) ..
                " / 100"
            );
    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "INVESTORS"
        );


    for _, investment
        in pairs(
            project.investments
            or {}
        ) do


        local name =
            GetPlayerName(
                game,
                investment.playerID
            );


        local role =
            "Investor";


        if investment.isCreator then
            role = "Creator";
        end


        UI.CreateLabel(area)
            .SetText(
                name ..
                " (" ..
                role ..
                ") | Invested: " ..
                tostring(
                    investment.amount
                    or 0
                ) ..
                " | Payout: " ..
                tostring(
                    investment.payout
                    or 0
                )
            );
    end


    UI.CreateButton(area)
        .SetText(
            "Back to Archive"
        )
        .SetOnClick(function()

            ShowInvestmentArchive(
                parent,
                game
            );

        end);
end


function ShowInvestmentHistory(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    local history =
        data.investmentHistory
        or {};


    UI.CreateLabel(area)
        .SetText(
            "GLOBAL INVESTMENT HISTORY"
        );


    if #history == 0 then


        UI.CreateLabel(area)
            .SetText(
                "No investment events recorded yet."
            );


        return;
    end


    local shown = 0;


    for i =
        #history,
        1,
        -1 do


        if shown
            >= MAX_VISIBLE_HISTORY then

            break;
        end


        local event =
            history[i];


        UI.CreateLabel(area)
            .SetText(
                "Turn " ..
                tostring(
                    event.turn
                    or "?"
                ) ..
                " - " ..
                tostring(
                    event.message
                    or "Investment event"
                )
            );


        shown =
            shown + 1;
    end
end
function ShowAIManagerMenu(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );

    UI.CreateButton(area)
        .SetText(
            "BACK TO OVERVIEW"
        )
        .SetOnClick(function()

            ShowOverview(
                parent,
                game
            );

        end);

    UI.CreateLabel(area)
        .SetText(
            "AI MANAGER"
        );

    UI.CreateLabel(area)
        .SetText(
            "Optional automation for your economy. The AI Manager can buy/sell stocks and create/invest in projects within your budget. It cannot control diplomacy, trade agreements, taxation, ideology, or military orders."
        );

    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );

    if GetClientSetting(
        "PlayerAIManagerEnabled",
        true
    ) ~= true then

        UI.CreateLabel(area)
            .SetText(
                "The host has disabled the AI Manager."
            );

        return;
    end

    local nation =
        GetOurNationState(
            game
        );

    if nation == nil
        or nation.setupComplete ~= true then

        UI.CreateLabel(area)
            .SetText(
                "Complete National Setup before using the AI Manager."
            );

        return;
    end

    local economy =
        (
            Mod.PublicGameData
            or {}
        ).globalEconomy
        or {};

    local enabled =
        nation.aiManagerEnabled == true;

    local cancelTurn =
        nation.aiManagerCancelTurn;

    local statusText =
        enabled
        and "ACTIVE"
        or "OFF";

    if enabled
        and cancelTurn ~= nil then

        statusText =
            "CANCEL PENDING - stops on Turn " ..
            tostring(
                cancelTurn
            );

    end

    UI.CreateLabel(area)
        .SetText(
            "Status: " ..
            statusText
        );

    UI.CreateLabel(area)
        .SetText(
            "Current Budget: " ..
            tostring(
                nation.aiManagerBudget
                or 100
            ) ..
            " gold per turn"
        );

    if enabled then

        UI.CreateLabel(area)
            .SetText(
                "Budget Remaining This Turn: " ..
                tostring(
                    nation.aiManagerBudgetRemaining
                    or 0
                )
            );

    end

    UI.CreateLabel(area)
        .SetText(
            "Set the maximum amount of gold the manager may spend in one turn. Minimum: 25."
        );

    local budgetInput =
        UI.CreateTextInputField(
            area
        );

    budgetInput.SetText(
        tostring(
            nation.aiManagerBudget
            or 100
        )
    );

    local quickBudgetRow =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    local function SetBudgetText(value)
        budgetInput.SetText(
            tostring(value)
        );
    end

    UI.CreateButton(quickBudgetRow)
        .SetText("100")
        .SetOnClick(function() SetBudgetText(100); end);

    UI.CreateButton(quickBudgetRow)
        .SetText("250")
        .SetOnClick(function() SetBudgetText(250); end);

    UI.CreateButton(quickBudgetRow)
        .SetText("500")
        .SetOnClick(function() SetBudgetText(500); end);

    UI.CreateButton(quickBudgetRow)
        .SetText("1000")
        .SetOnClick(function() SetBudgetText(1000); end);

    local actionRow =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    local function SendManagerUpdate(
        shouldEnable
    )

        local budget =
            tonumber(
                budgetInput.GetText()
            );

        if budget == nil then

            UI.Alert(
                "Enter a valid budget amount."
            );

            return;
        end

        budget =
            math.max(
                25,
                math.floor(
                    budget
                )
            );

        game.SendGameCustomMessage(
            "Updating AI Manager...",
            {
                type =
                    "updateAIManager",

                enabled =
                    shouldEnable,

                budget =
                    budget
            },
            function(result)

                if result ~= nil
                    and result.message ~= nil then

                    UI.Alert(
                        result.message
                    );

                end

                ShowAIManagerMenu(
                    parent,
                    game
                );

            end
        );

    end

    UI.CreateButton(actionRow)
        .SetText(
            enabled
            and "UPDATE BUDGET"
            or "ENABLE MANAGER"
        )
        .SetOnClick(function()
            SendManagerUpdate(true);
        end);

    if enabled
        and cancelTurn == nil then

        UI.CreateButton(actionRow)
            .SetText(
                "CANCEL MANAGER"
            )
            .SetOnClick(function()
                SendManagerUpdate(false);
            end);

    end

    UI.CreateLabel(area)
        .SetText(
            "Cancellation rule: once requested, cancellation becomes effective on the next economy turn."
        );

end


function ShowGlobalEconomy(
    parent,
    game,
    filter
)

    local area =
        CreateContentArea(
            parent
        );


    local data =
        Mod.PublicGameData or {};


    local history =
        data.tradeHistory
        or {};


    UI.CreateLabel(area)
        .SetText(
            "GLOBAL ECONOMY"
        );


    UI.CreateLabel(area)
        .SetText(
            "Track major international trade and investment activity."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    local tabs =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(tabs)
        .SetText(
            "All"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "all"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Signed"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "signed"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Proposals"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "proposals"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Rejected"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "rejected"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Canceled"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "canceled"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Investments"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "investments"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Success"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "success"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "Failed"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "failed"
            );

        end);


    UI.CreateButton(tabs)
        .SetText(
            "AI"
        )
        .SetOnClick(function()

            ShowGlobalEconomy(
                parent,
                game,
                "ai"
            );

        end);


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    local shown =
        0;


    local found =
        false;


    for i =
        #history,
        1,
        -1 do


        if shown
            >= MAX_VISIBLE_HISTORY then

            break;
        end


        local event =
            history[i];


        if EventPassesFilter(
            event.type,
            filter or "all"
        ) then


            found =
                true;


            UI.CreateLabel(area)
                .SetText(
                    "Turn " ..
                    tostring(
                        event.turn
                        or "?"
                    ) ..
                    " - " ..
                    tostring(
                        event.message
                        or "Economic event"
                    )
                );


            shown =
                shown + 1;
        end
    end


    if not found then


        UI.CreateLabel(area)
            .SetText(
                "No events match this category yet."
            );
    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateButton(area)
        .SetText(
            "Investment History"
        )
        .SetOnClick(function()

            ShowInvestmentHistory(
                parent,
                game
            );

        end);
end


function ShowHowItWorks(parent)

    local area =
        CreateContentArea(
            parent
        );


    UI.CreateLabel(area)
        .SetText(
            "HOW IT WORKS"
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "TRADE AGREEMENTS\n\n" ..

            "Trade Agreements are bilateral economic relationships between two active nations.\n\n" ..

            "Each nation receives a recurring Commerce bonus based on the current Commerce income of its partner.\n\n" ..

            "Trade benefit rate: " ..
            tostring(
                ClientTradeBonusPercent()
            ) ..
            "% of your partner's Commerce income.\n\n" ..

            "Maximum agreements per nation: " ..
            tostring(
                ClientMaxAgreements()
            ) ..
            ".\n\n" ..

            "Rejection/cancellation cooldown: " ..
            tostring(
                ClientTradeCooldownTurns()
            ) ..
            " turn(s).\n\n" ..

            "Trade income changes dynamically as your partner's Commerce economy changes."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "SMARTER AI TRADE BEHAVIOR\n\n" ..

            "AI nations evaluate the economic strength of potential partners.\n\n" ..

            "AI nations remember the income direction of active trade partners.\n\n" ..

            "A single weak turn does not cause panic. Repeated economic decline builds concern.\n\n" ..

            "The host controls how many consecutive declining turns are required before AI concern begins.\n\n" ..

            "AI nations also respect a minimum agreement duration before replacing established partners.\n\n" ..

            "Replacement requires a substantially stronger alternative, helping prevent constant partner cycling."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "INVESTMENTS\n\n" ..

            "Creators choose their project funding goal and must contribute at least 20%.\n\n" ..

            "Each outside investor may invest up to 25% of the project's funding goal.\n\n" ..

            "Once full funding is reached, the project enters development for its listed duration.\n\n" ..

            "Successful projects return principal plus profit.\n\n" ..

            "Failed projects return only their listed recovery percentage.\n\n" ..

            "Projects that fail to reach their funding goal before the deadline expire and refund principal.\n\n" ..

            "AI nations may create projects and invest in other projects when enabled by the host."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "PERMANENT PROJECT ARCHIVE\n\n" ..

            "Completed, failed, and expired projects are removed from the active market but remain stored in the Archive.\n\n" ..

            "The archive records the creator, funding, investors, contribution amounts, payouts, turns, result, and resolution roll."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "STRATEGIC RESOURCES\n\n" ..

            "Resources are produced by territories you control. Capturing a resource territory transfers its production to the new owner automatically.\n\n" ..

            "Resources are not stockpiled. Each turn, production is calculated, active resource trades are applied, and then shortages are checked.\n\n" ..

            "Existing armies are NEVER removed because of a shortage. Resource shortages affect your future economic and military mobilization capacity instead.\n\n" ..

            "Commerce Example: If your nation earns 400 Commerce and resource shortages create a 10% penalty, the resource system removes 40 Commerce that turn.\n\n" ..

            "Military Readiness is a national indicator from 50% to 100%. Oil, Food, Iron, and Gas shortages lower readiness. A lower value means your country is less prepared to sustain new military mobilization; it does not destroy armies already on the map.\n\n" ..

            "RESOURCE ROLES\n" ..
            "Oil - major military mobilization support.\n" ..
            "Gas - economy and military support.\n" ..
            "Food - population, army sustainment, and stability.\n" ..
            "Iron - military and industrial production.\n" ..
            "Uranium - strategic / advanced military resource.\n" ..
            "Rare Earths - advanced technology and military systems.\n" ..
            "Coal - industrial Commerce.\n" ..
            "Copper - infrastructure and industry.\n" ..
            "Lithium - advanced industry and technology.\n\n" ..

            "RESOURCE HUB ICON\n" ..
            "A resource territory shows one Resource Hub structure icon. The number beside the icon is the TOTAL facility/deposit level on that territory.\n\n" ..

            "Example: A Resource Hub showing 4 could contain Oil level 2, Iron level 1, and Food level 1. The map stays clean while the Resources menu keeps the full breakdown.\n\n" ..

            "RESOURCE TRADE EXAMPLE\n" ..
            "If France produces extra Oil but lacks Food, it can sell Oil to another nation for gold and buy Food from a different partner. Contracts move current-turn production every turn while active."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    UI.CreateLabel(area)
        .SetText(
            "HOST CONFIGURATION\n\n" ..

            "Hosts can configure the maximum number of trade agreements from 1 to 20, trade bonus percentage, cooldown duration, AI proposal frequency, minimum AI agreement duration, AI replacement threshold, economic decline sensitivity, AI investment behavior, and AI treasury reserve."
        );
end


-- =========================================================
-- NATIONAL SETUP / ECONOMIC REFORM
-- =========================================================

function GetOurNationState(game)

    local data =
        Mod.PublicGameData or {};


    local economy =
        data.globalEconomy or {};


    local nations =
        economy.nations or {};


    if game == nil
        or game.Us == nil then


        return nil;

    end


    return nations[
        game.Us.ID
    ];
end


function IsNationalSetupComplete(game)

    local nation =
        GetOurNationState(
            game
        );


    return nation ~= nil
        and nation.setupComplete == true;
end
function ShowNationalSetup(
    parent,
    game
)

    local area =
        CreateContentArea(
            parent
        );


    local nation =
        GetOurNationState(
            game
        );


    local isReform =
        nation ~= nil
        and nation.setupComplete == true;


    local economy =
        (
            Mod.PublicGameData
            or {}
        ).globalEconomy
        or {};


    local currentTurn =
        economy.currentEconomyTurn
        or 1;


    -- =====================================================
    -- ACTIVE REFORM
    -- =====================================================

    if isReform
        and nation.reformActive == true then


        local reformEndTurn =
            nation.reformEndTurn
            or currentTurn;


        local turnsRemaining =
            reformEndTurn
            - currentTurn;


        if turnsRemaining < 0 then

            turnsRemaining =
                0;

        end


        UI.CreateLabel(area)
            .SetText(
                "ECONOMIC REFORM IN PROGRESS"
            );


        UI.CreateLabel(area)
            .SetText(
                "Your new national policies are already active."
            );


        UI.CreateLabel(area)
            .SetText(
                "----------------------------------------"
            );


        UI.CreateLabel(area)
            .SetText(
                "Ideology: " ..
                tostring(
                    nation.ideology
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Economic Strategy: " ..
                tostring(
                    nation.economicStrategy
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Tax Policy: " ..
                tostring(
                    nation.taxPolicy
                    or "Standard"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Flagship Company: " ..
                tostring(
                    nation.flagshipCompanyName
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Company Strategy: " ..
                tostring(
                    nation.companyStrategy
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "----------------------------------------"
            );


        UI.CreateLabel(area)
            .SetText(
                "Temporary Economic Confidence Penalty: -" ..
                tostring(
                    nation.reformPenaltyPercent
                    or 15
                ) ..
                "%"
            );


        UI.CreateLabel(area)
            .SetText(
                "Effective Economic Confidence: " ..
                tostring(
                    nation.effectiveEconomicConfidence
                    or 85
                ) ..
                "%"
            );


        UI.CreateLabel(area)
            .SetText(
                "Turns Remaining: " ..
                tostring(
                    turnsRemaining
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "When reform ends, the temporary confidence penalty disappears automatically. Your new ideology and strategies remain."
            );


        UI.CreateButton(area)
            .SetText(
                "BACK TO OVERVIEW"
            )
            .SetOnClick(function()


                ShowOverview(
                    parent,
                    game
                );

            end);


        return;

    end


    -- =====================================================
    -- TITLE
    -- =====================================================

    if isReform then


        UI.CreateLabel(area)
            .SetText(
                "NATIONAL POLICY & ECONOMIC REFORM"
            );


        UI.CreateLabel(area)
            .SetText(
                "You may change your nation's economic direction, but major policy changes create temporary economic uncertainty."
            );


        UI.CreateLabel(area)
            .SetText(
                "Major Reform: -15% Economic Confidence for 3 turns."
            );


        UI.CreateLabel(area)
            .SetText(
                "Changing only your tax policy does not trigger the full reform penalty."
            );


        UI.CreateLabel(area)
            .SetText(
                "Your flagship company's name remains unchanged."
            );


    else


        UI.CreateLabel(area)
            .SetText(
                "NATIONAL ECONOMIC SETUP"
            );


        UI.CreateLabel(area)
            .SetText(
                "Establish your nation's starting economic identity."
            );


        UI.CreateLabel(area)
            .SetText(
                "Choose an ideology, economic strategy, starting tax policy, flagship company, and company strategy."
            );

    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- SELECTION STATE
    -- =====================================================

    local selectedIdeology =
        isReform
        and nation.ideology
        or nil;


    local selectedEconomicStrategy =
        isReform
        and nation.economicStrategy
        or nil;


    local selectedTaxPolicy =
        isReform
        and (
            nation.taxPolicy
            or "Standard"
        )
        or "Standard";


    local selectedCompanyStrategy =
        isReform
        and nation.companyStrategy
        or nil;

    local ideologyEffectsLabel =
    nil;

    local policyPreviewLabel =
    nil;

    local companyNameInput =
        nil;


    local ideologyLabel =
        UI.CreateLabel(
            area
        );


    local economicStrategyLabel =
        UI.CreateLabel(
            area
        );


    local taxLabel =
        UI.CreateLabel(
            area
        );


    local companyStrategyLabel =
        UI.CreateLabel(
            area
        );

local function GetIdeologyEffectsText(
    ideology
)

    if ideology == "Free Market" then
        return "Ideology Effects - Free Market\nGovernment Commerce: -3% | Market: +8% | Investment: +6% | Company Confidence: +2";
    elseif ideology == "Capitalist" then
        return "Ideology Effects - Capitalist\nGovernment Commerce: -2% | Market: +6% | Investment: +5% | Company Confidence: +3";
    elseif ideology == "Social Democratic" then
        return "Ideology Effects - Social Democratic\nGovernment Commerce: +2% | Market: +2% | Investment: +3% | Company Confidence: +2";
    elseif ideology == "State Capitalist" then
        return "Ideology Effects - State Capitalist\nGovernment Commerce: +4% | Market: +1% | Investment: +5% | Company Confidence: +4";
    elseif ideology == "Socialist" then
        return "Ideology Effects - Socialist\nGovernment Commerce: +5% | Market: -5% | Investment: +1% | Company Confidence: +1";
    elseif ideology == "Communist" then
        return "Ideology Effects - Communist\nGovernment Commerce: +7% | Market: -9% | Investment: -2% | Company Confidence: +0";
    elseif ideology == "Fascist" then
        return "Ideology Effects - Fascist\nGovernment Commerce: +3% | Market: -2% | Investment: +1% | Company Confidence: +3";
    elseif ideology == "Nationalist" then
        return "Ideology Effects - Nationalist\nGovernment Commerce: +2% | Market: -1% | Investment: +0% | Company Confidence: +2";
    end

    return "Ideology Effects: None";
end

    local function UpdateSelections()


        ideologyLabel.SetText(
            "Selected Ideology: " ..
            tostring(
                selectedIdeology
                or "None"
            )
        );


        economicStrategyLabel.SetText(
            "Selected Economic Strategy: " ..
            tostring(
                selectedEconomicStrategy
                or "None"
            )
        );


        taxLabel.SetText(
            "Selected Tax Policy: " ..
            tostring(
                selectedTaxPolicy
                or "None"
            )
        );

        if ideologyEffectsLabel ~= nil then

    ideologyEffectsLabel.SetText(
        GetIdeologyEffectsText(
            selectedIdeology
        )
    );

end

if policyPreviewLabel ~= nil then

    policyPreviewLabel.SetText(
        GetPolicyPreviewText(
            game,
            selectedTaxPolicy,
            selectedIdeology
        )
    );

end

        companyStrategyLabel.SetText(
            "Selected Company Strategy: " ..
            tostring(
                selectedCompanyStrategy
                or "None"
            )
        );

    end


    UpdateSelections();


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- IDEOLOGY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "1. IDEOLOGY"
        );


    local ideologyRow1 =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(
        ideologyRow1
    )
        .SetText(
            "Free Market"
        )
        .SetOnClick(function()


            selectedIdeology =
                "Free Market";


            UpdateSelections();

        end);


    UI.CreateButton(
        ideologyRow1
    )
        .SetText(
            "Capitalist"
        )
        .SetOnClick(function()


            selectedIdeology =
                "Capitalist";


            UpdateSelections();

        end);


    UI.CreateButton(
        ideologyRow1
    )
        .SetText(
            "Social Democratic"
        )
        .SetOnClick(function()


            selectedIdeology =
                "Social Democratic";


            UpdateSelections();

        end);


    local ideologyRow2 =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(
        ideologyRow2
    )
        .SetText(
            "State Capitalist"
        )
        .SetOnClick(function()


            selectedIdeology =
                "State Capitalist";


            UpdateSelections();

        end);


    UI.CreateButton(
        ideologyRow2
    )
        .SetText(
            "Socialist"
        )
        .SetOnClick(function()


            selectedIdeology =
                "Socialist";


            UpdateSelections();

        end);


    local ideologyRow3 =
        UI.CreateHorizontalLayoutGroup(
            area
        );

    UI.CreateButton(ideologyRow3)
        .SetText("Communist")
        .SetOnClick(function()
            selectedIdeology = "Communist";
            UpdateSelections();
        end);

    UI.CreateButton(ideologyRow3)
        .SetText("Fascist")
        .SetOnClick(function()
            selectedIdeology = "Fascist";
            UpdateSelections();
        end);

    UI.CreateButton(ideologyRow3)
        .SetText("Nationalist")
        .SetOnClick(function()
            selectedIdeology = "Nationalist";
            UpdateSelections();
        end);

    UI.CreateLabel(area)
        .SetText(
            "Free Market - private-market growth and investment upside, with greater volatility.\n" ..
            "Capitalist - strong private companies, investment activity, and shareholder returns.\n" ..
            "Social Democratic - balanced markets, taxation, public development, and stability.\n" ..
            "State Capitalist - government-directed development and strategic intervention.\n" ..
            "Socialist - stronger public development and stability with less private-market upside.\n" ..
            "Communist - strong state Commerce and public control, with much weaker private-market activity.\n" ..
            "Fascist - state-directed mobilization and company confidence, with constrained private markets.\n" ..
            "Nationalist - domestic Commerce and national industry focus with limited foreign-market emphasis."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- ECONOMIC STRATEGY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "2. ECONOMIC STRATEGY"
        );


    local strategyRow =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(
        strategyRow
    )
        .SetText(
            "Growth"
        )
        .SetOnClick(function()


            selectedEconomicStrategy =
                "Growth";


            UpdateSelections();

        end);


    UI.CreateButton(
        strategyRow
    )
        .SetText(
            "Balanced"
        )
        .SetOnClick(function()


            selectedEconomicStrategy =
                "Balanced";


            UpdateSelections();

        end);


    UI.CreateButton(
        strategyRow
    )
        .SetText(
            "Conservative"
        )
        .SetOnClick(function()


            selectedEconomicStrategy =
                "Conservative";


            UpdateSelections();

        end);


    UI.CreateLabel(area)
        .SetText(
            "Growth - prioritizes expansion and long-term upside.\n" ..
            "Balanced - mixes expansion, reserves, and financial stability.\n" ..
            "Conservative - prioritizes reserves and lower financial risk."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- TAX POLICY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "3. TAX POLICY"
        );


    local taxRow =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(
        taxRow
    )
        .SetText(
            "Low"
        )
        .SetOnClick(function()


            selectedTaxPolicy =
                "Low";


            UpdateSelections();

        end);


    UI.CreateButton(
        taxRow
    )
        .SetText(
            "Standard"
        )
        .SetOnClick(function()


            selectedTaxPolicy =
                "Standard";


            UpdateSelections();

        end);


    UI.CreateButton(
        taxRow
    )
        .SetText(
            "High"
        )
        .SetOnClick(function()


            selectedTaxPolicy =
                "High";


            UpdateSelections();

        end);


UI.CreateLabel(area)
    .SetText(
        "Low Tax\n" ..
        "Commerce: -10% | Market: +10% | Investment: +10% | Company Confidence: +5\n\n" ..

        "Standard Tax\n" ..
        "Commerce: 0% | Market: 0% | Investment: 0% | Company Confidence: 0\n\n" ..

        "High Tax\n" ..
        "Commerce: +10% | Market: -10% | Investment: -10% | Company Confidence: -5"
    );

ideologyEffectsLabel =
    UI.CreateLabel(area);

ideologyEffectsLabel.SetText(
    GetIdeologyEffectsText(
        selectedIdeology
    )
);

policyPreviewLabel =
    UI.CreateLabel(area);

policyPreviewLabel.SetText(
    GetPolicyPreviewText(
        game,
        selectedTaxPolicy,
        selectedIdeology
    )
);

UI.CreateLabel(area)
    .SetText(
        "--------------------------------"
    );

    -- =====================================================
    -- FLAGSHIP COMPANY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "4. FLAGSHIP COMPANY"
        );


    if isReform then


        UI.CreateLabel(area)
            .SetText(
                "Current Company: " ..
                tostring(
                    nation.flagshipCompanyName
                    or "Unknown"
                )
            );


        UI.CreateLabel(area)
            .SetText(
                "Corporate renaming will be handled separately from national economic reform."
            );


    else


        UI.CreateLabel(area)
            .SetText(
                "Enter a unique company name between 2 and 40 characters."
            );


        companyNameInput =
            UI.CreateTextInputField(
                area
            )
                .SetPlaceholderText(
                    "Enter flagship company name..."
                );

    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- COMPANY STRATEGY
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            "5. COMPANY STRATEGY"
        );


    local companyStrategyRow =
        UI.CreateHorizontalLayoutGroup(
            area
        );


    UI.CreateButton(
        companyStrategyRow
    )
        .SetText(
            "Growth"
        )
        .SetOnClick(function()


            selectedCompanyStrategy =
                "Growth";


            UpdateSelections();

        end);


    UI.CreateButton(
        companyStrategyRow
    )
        .SetText(
            "Balanced"
        )
        .SetOnClick(function()


            selectedCompanyStrategy =
                "Balanced";


            UpdateSelections();

        end);


    UI.CreateButton(
        companyStrategyRow
    )
        .SetText(
            "Dividend"
        )
        .SetOnClick(function()


            selectedCompanyStrategy =
                "Dividend";


            UpdateSelections();

        end);


    UI.CreateLabel(area)
        .SetText(
            "Growth Company - greater appreciation potential with lower dividends and higher volatility.\n" ..
            "Balanced Company - moderate appreciation, dividends, and volatility.\n" ..
            "Dividend Company - lower appreciation potential with stronger recurring dividends."
        );


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- DIPLOMACY ACKNOWLEDGEMENT
    -- =====================================================

    if not isReform then


        UI.CreateLabel(area)
            .SetText(
                "6. DIPLOMACY RULE"
            );


        UI.CreateLabel(area)
            .SetText(
                "When formal diplomacy is enabled, nations must officially declare WAR before attacking another nation. Confirming National Setup acknowledges this rule."
            );


        UI.CreateLabel(area)
            .SetText(
                "----------------------------------------"
            );

    end


    -- =====================================================
    -- FINAL REVIEW
    -- =====================================================

    UI.CreateLabel(area)
        .SetText(
            isReform
            and "PROPOSED NATIONAL POLICY"
            or "YOUR STARTING NATIONAL POLICY"
        );


    UpdateSelections();


    if isReform then


        UI.CreateLabel(area)
            .SetText(
                "Major Change: ideology, economic strategy, or company strategy.\n" ..
                "Major Reform Penalty: -15% Economic Confidence for 3 turns.\n" ..
                "Tax-only Change: no full economic reform penalty."
            );

    end


    UI.CreateLabel(area)
        .SetText(
            "----------------------------------------"
        );


    -- =====================================================
    -- SUBMIT
    -- =====================================================

    UI.CreateButton(area)
        .SetText(
            isReform
            and "CONFIRM ECONOMIC REFORM"
            or "CONFIRM NATIONAL SETUP"
        )
        .SetOnClick(function()


            if selectedIdeology
                == nil then


                UI.Alert(
                    "Please choose an ideology."
                );


                return;

            end


            if selectedEconomicStrategy
                == nil then


                UI.Alert(
                    "Please choose an economic strategy."
                );


                return;

            end


            if selectedTaxPolicy
                == nil then


                UI.Alert(
                    "Please choose a tax policy."
                );


                return;

            end


            if selectedCompanyStrategy
                == nil then


                UI.Alert(
                    "Please choose a company strategy."
                );


                return;

            end


            -- =================================================
            -- EXISTING NATION -> REFORM
            -- =================================================

            if isReform then


                if selectedIdeology
                        == nation.ideology

                    and selectedEconomicStrategy
                        == nation.economicStrategy

                    and selectedTaxPolicy
                        == nation.taxPolicy

                    and selectedCompanyStrategy
                        == nation.companyStrategy
                then


                    UI.Alert(
                        "No national policies were changed."
                    );


                    return;

                end


                game.SendGameCustomMessage(
                    "Submitting economic reform...",

                    {

                        type =
                            "reformNationalSetup",

                        ideology =
                            selectedIdeology,

                        economicStrategy =
                            selectedEconomicStrategy,

                        taxPolicy =
                            selectedTaxPolicy,

                        companyStrategy =
                            selectedCompanyStrategy

                    },

                    function(result)


                        UI.Alert(
                            result
                            and result.message
                            or
                            "Economic reform request processed."
                        );


                        if result ~= nil
                            and result.success then


                            ShowOverview(
                                parent,
                                game
                            );

                        end

                    end
                );


                return;

            end


            -- =================================================
            -- FIRST NATIONAL SETUP
            -- =================================================

            local companyName =
                companyNameInput.GetText();


            if companyName == nil
                or string.len(
                    companyName
                ) < 2 then


                UI.Alert(
                    "Please enter a flagship company name with at least 2 characters."
                );


                return;

            end


            game.SendGameCustomMessage(
                "Saving National Setup...",

                {

                    type =
                        "saveNationalSetup",

                    ideology =
                        selectedIdeology,

                    economicStrategy =
                        selectedEconomicStrategy,

                    taxPolicy =
                        selectedTaxPolicy,

                    companyName =
                        companyName,

                    companyStrategy =
                        selectedCompanyStrategy,

                    warRulesAcknowledged =
                        true

                },

                function(result)


                    UI.Alert(
                        result
                        and result.message
                        or
                        "National Setup request processed."
                    );


                    if result ~= nil
                        and result.success then


                        ShowOverview(
                            parent,
                            game
                        );

                    end

                end
            );

        end);


    if isReform then


        UI.CreateButton(area)
            .SetText(
                "CANCEL / BACK TO OVERVIEW"
            )
            .SetOnClick(function()


                ShowOverview(
                    parent,
                    game
                );

            end);

    end

end