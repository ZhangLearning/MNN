pushd ./build
./llm_demo ~/dev_workspace/DeepSeek-R1-1.5B-Qwen-MNN/config.json ~/dev_workspace/MNN/prompt.txt
popd

# 同步到多台主机上执行相同shell命令
ansible -i xft.host xft -m shell -a 'free -g'

# 打包conda 虚拟环境，需要安装conda-pack 包，pip 或者 conda install
pip install conda-pack
conda install -c conda-forge conda-pack
conda pack -n pyenv-xft -o pyenv-xft_20250429.tar.gz


# 创建conda虚拟环境
conda --version
conda create --name mnn-py312-env python=3.12 -y
conda activate mnn-py312-env
#迁移到目标集群
mkdir -p /usr/local/app/miniconda3/envs/test1
tar -zxvf test1.tar.gz -C /usr/local/app/miniconda3/envs/test1
conda activate test1
#删除虚拟环境，以test为例
conda deactivate # 退出当前环境
conda env remove -n test -y # 删除环境

# 模型转换python脚本转换
python3 -m pip install -r /home/harvey/dev_workspace/MNN/transformers/llm/export/requirements.txt

cd ./MNN/transformers/llm/export
python3 ./llmexport.py \
    --path ~/dev_workspace/models/Qwen3-30B-A3B/ \
    --export mnn \
    --quant_bit 4 \
    --quant_block 128 \
    --dst_path ~/dev_workspace/models/Qwen3-30B-A3B-MNN/
cd -

# 模型测试demo
# ./llm_demo /home/harvey/dev_workspace/MNN/transformers/llm/export/model/llm_config.json prompt.txt

# 模型转换C++接口
# cd ./transformers/llm/export
# python3 ./llmexport.py --path ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B/ --export mnn --quant_bit 4 --quant_block 128 --dst_path ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B-MNN

./MNNConvert --modelFile ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B-MNN-ONNX/onnx/llm.onnx --MNNModel ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B-MNN-ONNX/llm-2bit.mnn --keepInputFormat --weightQuantBits=2 --weightQuantBlock=128 -f ONNX --transformerFuse=1 --allowCustomOp --saveExternalData --info


# 模型验证
# cd ./build
# python ../tools/script/testMNNFromOnnx.py mobilenetv2-7.onnx

# 修改cl kernel 文件后需要手动执行
cd ./source/backend/opencl/execution/cl
python3 ./opencl_codegen.py . ./opencl_program.cc



modelscope download --model 'MNN/Qwen3-0.6B-MNN' --local_dir ~/dev_workspace/models/Qwen3-0.6B-MNN
