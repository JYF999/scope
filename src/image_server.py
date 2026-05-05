import importlib.util


_SPEC = importlib.util.spec_from_file_location(
    "v43_image_server", "/pfs/yufei/Reprompt/test/score_72_8B_v43/image_server.py"
)
if _SPEC is None or _SPEC.loader is None:
    raise RuntimeError("Failed to load image_server module from v43.")
_MOD = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(_MOD)

app = _MOD.app
