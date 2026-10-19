# Row-transfer addition repair

Time: 2026-10-19T12:26:23.891181+02:00

The actual pinned compiler rejected `add_le_add_left herrsum _` because its inferred summand order did not match the calc step. Use `add_le_add le_rfl herrsum`, preserving the exact statement and all assumptions. Original failed source/log: wave02. Recompilation and audits remain pending.
