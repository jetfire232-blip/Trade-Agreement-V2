-- Live AI takeover detection shared by server hooks. No saved isAI flag is trusted.
function GAIsAIControlled(player)
    return player~=nil and (player.IsAIOrHumanTurnedIntoAI==true
        or player.HumanTurnedIntoAI==true or player.IsAI==true);
end

function GARepairAINationalSetups(game,data,ensureNation,getIncome,getStartingPrice)
    local standing=game.ServerGame and game.ServerGame.LatestTurnStanding;
    if not standing or not standing.Territories then return 0; end
    local owned={}; for _,terr in pairs(standing.Territories) do
        local id=terr.OwnerPlayerID; if id~=nil then owned[id]=(owned[id] or 0)+1; end
    end
    data.globalEconomy=data.globalEconomy or {};
    local economy=data.globalEconomy; economy.nations=economy.nations or {};
    economy.market=economy.market or {}; local market=economy.market;
    market.companies=market.companies or {};
    local turn=tonumber(economy.currentEconomyTurn) or tonumber(data.tradeTurn) or 0;
    local fixed=0;
    local ideologies={['Free Market']=true,Capitalist=true,['Social Democratic']=true,['State Capitalist']=true,Socialist=true,Communist=true,Fascist=true,Nationalist=true};
    local strategies={Growth=true,Balanced=true,Conservative=true};
    local taxes={Low=true,Standard=true,High=true};
    local companies={Growth=true,Balanced=true,Dividend=true};
    local profiles={{'Free Market','Growth','Low','Growth','Growth'},{'Capitalist','Growth','Standard','Balanced','Investor'},{'Social Democratic','Balanced','Standard','Dividend','Balanced'},{'State Capitalist','Balanced','High','Balanced','Planner'},{'Socialist','Conservative','High','Dividend','Conservative'}};
    for id,player in pairs(game.Game.Players or {}) do
        if GAIsAIControlled(player) and player.Surrendered~=true and (owned[id] or 0)>0 then
            local nation=ensureNation(id); nation.isAI=true;
            if nation.setupComplete~=true then
                local income=math.max(0,tonumber(getIncome(id)) or 0);
                local profile=profiles[((tonumber(id) or 0)+math.floor(income))%5+1];
                if not ideologies[nation.ideology] then nation.ideology=profile[1]; end
                if not strategies[nation.economicStrategy] then nation.economicStrategy=profile[2]; end
                if not taxes[nation.taxPolicy] then nation.taxPolicy=profile[3]; end
                if not companies[nation.companyStrategy] then nation.companyStrategy=profile[4]; end
                nation.aiProfile=nation.aiProfile or profile[5];
                nation.companies=nation.companies or {}; nation.stockHoldings=nation.stockHoldings or {}; nation.stockCostBasis=nation.stockCostBasis or {};
                local companyID=nation.flagshipCompanyID;
                local company=companyID and market.companies[companyID];
                if not company or company.ownerPlayerID~=id or company.active~=true then
                    company=nil;
                    for cid,c in pairs(market.companies) do if c.ownerPlayerID==id and c.active==true and c.delisted~=true then companyID=cid; company=c; break; end end
                end
                if not company then
                    companyID=math.max(1,math.floor(tonumber(market.nextCompanyID) or 1));
                    while market.companies[companyID]~=nil do companyID=companyID+1; end
                    market.nextCompanyID=companyID+1;
                    local name=nation.flagshipCompanyName;
                    if type(name)~='string' or #name<2 then name='AI '..tostring(id)..' Holdings'; end
                    name=string.sub(name,1,40);
                    local function used(n)for _,c in pairs(market.companies)do if string.lower(tostring(c.name or ''))==string.lower(n)then return true end end;return false end
                    if used(name) then local base=string.sub(name,1,20);local suffix=1;repeat name=base..' '..tostring(companyID)..'-'..tostring(suffix);suffix=suffix+1 until not used(name);end
                    local price=math.max(1,math.floor((tonumber(getStartingPrice(id)) or 30)+0.5));
                    local founder=math.floor(math.max(0,math.min(100,tonumber((Mod.Settings or {}).FounderSharePercent) or 20))+0.5);
                    company={id=companyID,name=name,ownerPlayerID=id,founderPlayerID=id,strategy=nation.companyStrategy,ideology=nation.ideology,nationStrategy=nation.economicStrategy,createdTurn=turn,status='trading',totalShares=100,founderShares=founder,publicShares=100-founder,sharesAvailable=100-founder,startingPrice=price,currentPrice=price,previousPrice=price,marketCap=100*price,dividendPerShare=0,totalDividendsPaid=0,priceHistory={{turn=turn,price=price}},etfMember=false,etfMemberTurns=0,confidence=50,effectiveConfidence=50,reformPenaltyPercent=0,volatility=tonumber((Mod.Settings or {}).StockVolatilityPercent) or 10,active=true,delisted=false};
                    market.companies[companyID]=company;
                    nation.stockHoldings[companyID]=founder;nation.stockCostBasis[companyID]=0;
                end
                local listed=false;for _,cid in pairs(nation.companies)do if cid==companyID then listed=true;break end end
                if not listed then table.insert(nation.companies,companyID);end
                nation.flagshipCompanyID=companyID;nation.flagshipCompanyName=company.name;nation.flagshipCompanyCreated=true;
                nation.baseEconomicConfidence=nation.baseEconomicConfidence or 100;
                nation.effectiveEconomicConfidence=nation.effectiveEconomicConfidence or 100;
                nation.setupComplete=true;nation.setupCompletedTurn=nation.setupCompletedTurn or turn;
                nation.aiSetupRepairTurn=turn;nation.eliminated=false;
                fixed=fixed+1;
            end
        end
    end
    return fixed;
end
