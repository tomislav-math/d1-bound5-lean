# Private GitHub Actions capacity investigation — read only

Date: 2026-10-18. Outcome: **free additional capacity NOT established; do not launch CI on this evidence**.

Authenticated GitHub CLI GET requests confirmed:

- Repository `tomislav-math/d1-bound5-lean` remains private, owner type User, default branch main. Existing authentication has repository admin/push permissions.
- Actions are enabled. Exactly one workflow exists: `Private Lean checks`, ID 385720766, `.github/workflows/lean.yml`, active, Git blob `8322962f207212473686a72b838d39af9a3aeb1f`.
- It is manual-only (`workflow_dispatch`), with required Boolean `free_allowance_confirmed`, default false, and an explicit job condition on that flag. It selects ubuntu-latest, timeout 45 minutes, LEAN_NUM_THREADS=1, read-only repository contents, pinned checkout/Lean-action commits, no GitHub cache, and invokes scripts/check.sh --replay.
- The repository has zero workflow runs. This does not determine account-wide usage or remaining allowance.
- The authenticated user response does not expose a plan. No plan was inferred.
- GET `/users/tomislav-math/settings/billing/actions` returned HTTP404.
- GET `/users/tomislav-math/settings/billing/usage/summary?year=2026&month=10&product=Actions` returned HTTP404.
- GET `/users/tomislav-math/settings/billing/usage?year=2026&month=10` returned HTTP404.
- For each billing request, gh explicitly reported that the operation needs the `user` scope. Authentication was not refreshed or broadened. No spending cap or payment-method state was obtained.

Current official GitHub documentation, read independently:

- Private standard runners consume the repository owner's included account allowance; overage can be charged. Larger runners are always charged. https://docs.github.com/en/billing/concepts/product-billing/github-actions
- Standard private ubuntu-latest currently provides 2 CPUs, 8GB RAM, 14GB SSD. It supplies another machine but not a larger per-job RAM budget than the present 8GB Mac. https://docs.github.com/en/actions/reference/runners/github-hosted-runners
- Personal billing usage APIs require Plan/read permission for fine-grained credentials. https://docs.github.com/en/rest/billing/usage
- The documented REST budgets endpoints shown are organization-scoped; personal budgets are described in the account billing UI. No unsupported endpoint or UI session was probed. https://docs.github.com/en/rest/billing/budgets and https://docs.github.com/en/billing/how-tos/set-up-budgets

The existing workflow's confirmation flag cannot honestly be set from the available evidence. The read-only investigation stops here. No workflow was created or modified; no job was dispatched; no privacy, billing, budget, permissions, or authentication setting changed; no token was printed. Root retains sole compiler/writer authority. The local serial verification remains the available verified route.
