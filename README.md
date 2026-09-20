# Global Affairs V3

A large-scale War.app Commerce, diplomacy, economic, market, resource, United Nations, and strategic-AI mod evolved from Trade Agreement V2.

## Core systems

- Bilateral Trade Agreements with recurring Commerce benefits.
- Investment projects with funding, risk, development time, success/failure, and AI participation.
- Stock market with flagship companies, founder shares, portfolios, dividends, stock splits, share issuance, ETF trading, and AI investors.
- Taxation and eight economic/political ideology choices.
- Diplomacy with wars, peace, NAPs, alliances, player search/overview, current-war statistics, and history.
- Player AI Manager for markets and investments with a player-defined budget.
- Strategic Resources with territory deposits, facility development, resource contracts, shortages, Military Readiness, Commerce penalties, and unrest.
- Optional United Nations / Security Council with permanent and rotating members, vetoes, AI voting, sanctions, embargoes, aid, condemnations, and ceasefires.
- War Events with player choices and automatic balanced resolution if a human does not respond in time.
- Mobile-focused UI, searchable Markets/Diplomacy, customizable tabs, and an expanded How It Works guide.

## Strategic Resources

Resources include Oil, Gas, Uranium, Iron, Food, Rare Earths, and optional Coal, Copper, and Lithium. Territory ownership determines production. Capturing a resource territory transfers its production to the new owner after the turn resolves. Nations that fall below their resource requirements can suffer Commerce penalties, lower Military Readiness, and unrest. Existing armies are never deleted by a shortage.

Each resource territory displays one dominant-resource map icon with a numeric badge for its combined facility/deposit level. Resource facility construction and upgrades cost gold. The host may disable resource icons globally while leaving the underlying resource economy active.

## United Nations / Security Council

The UN is optional and host-configurable. The default council uses five permanent and ten rotating seats. Permanent members may veto Security Council resolutions. Human council members vote YES / NO / ABSTAIN; AI council members vote automatically. Proposal cooldowns prevent spam.

Initial resolutions: Sanctions, Embargo, Economic Aid, Condemnation, and Ceasefire.

## Current Wars and War Events

Current Wars tracks war start turn, duration, attacks, combat losses, territories captured, and direct wartime decision costs. Human nations periodically receive strategic wartime choices when enabled by the host. If a choice is ignored for one turn, the mod applies a balanced response automatically.

## Performance architecture

Phase 8 adds large-game performance safeguards:

- Commerce income and stored gold are cached once per player per advance.
- AI strategic threat information is calculated in one shared map pass rather than one full-map scan per AI.
- City selection uses cached owned-territory lists.
- Peace-border deployment checks are cached per territory during the order phase.
- War combat statistics are accumulated and persisted once at the end of the turn rather than writing PublicGameData on every attack.
- Non-urgent AI diplomacy, trade, city, and economy work is staggered automatically as player counts grow.
- Incoming diplomacy offers, resource processing, UN effects, active agreements, and critical turn-state maintenance still run every turn.

The design target is normal-game advances around or below 20 seconds and Mega Game advances below roughly 30 seconds, subject to map size, number of orders, player count, and War.app server conditions.

## Testing

For a release candidate, test a fresh multiplayer game and verify Trade, Investments, Markets, Dividends/ETF, Taxation/Ideology, AI Manager, Resources, UN, Current Wars, War Events, mobile UI, resource captures, eliminated players, and late-game turn performance.
