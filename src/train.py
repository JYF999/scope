import os
import runpy


if __name__ == "__main__":
    # v43 train.py hardcodes deepspeed="ds_zero2_bf16.json".
    # Keep a single config copy under scope/configs by switching cwd here.
    os.chdir("/pfs/yufei/Reprompt/test/scope/configs")
    runpy.run_path("/pfs/yufei/Reprompt/test/score_72_8B_v43/train.py", run_name="__main__")
