import importlib.util


_SPEC = importlib.util.spec_from_file_location(
    "v43_reward_client", "/pfs/yufei/Reprompt/test/score_72_8B_v43/reward_client.py"
)
if _SPEC is None or _SPEC.loader is None:
    raise RuntimeError("Failed to load reward_client module from v43.")
_MOD = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(_MOD)

RewardClient = _MOD.RewardClient
FIXED_SEED_POOL = _MOD.FIXED_SEED_POOL
