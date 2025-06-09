pushd ./build
./llm_demo ~/dev_workspace/DeepSeek-R1-1.5B-Qwen-MNN/config.json ~/dev_workspace/MNN/prompt.txt
popd


#
cd ./MNN/transformers/llm/export
python3 ./llmexport.py \
    --path /tmp/DeepSeek-R1-Distill-Qwen-32B \
    --export mnn \
    --quant_bit 4 \
    --quant_block 128 \
    --dst_path ~/dev_workspace/DeepSeek-R1-Distill-Qwen-32B-MNN
cd -

# 模型测试demo
# ./llm_demo /home/harvey/dev_workspace/MNN/transformers/llm/export/model/llm_config.json prompt.txt

# 模型转换
# cd ./transformers/llm/export
# python3 ./llmexport.py --path ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B/ --export mnn --quant_bit 4 --quant_block 128 --dst_path ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B-MNN

./MNNConvert --modelFile ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B-MNN-ONNX/onnx/llm.onnx --MNNModel ~/dev_workspace/Model_files/DeepSeek-R1-Distill-Qwen-1.5B-MNN-ONNX/llm-2bit.mnn --keepInputFormat --weightQuantBits=2 --weightQuantBlock=128 -f ONNX --transformerFuse=1 --allowCustomOp --saveExternalData --info


# 模型验证
# cd ./build
# python ../tools/script/testMNNFromOnnx.py mobilenetv2-7.onnx

# 修改cl kernel 文件后需要手动执行
cd ./source/backend/opencl/execution/cl
python3 ./opencl_codegen.py . ./opencl_program.cc
