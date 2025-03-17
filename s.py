import os

def generate_asset_paths(directory, prefix=""):
    paths = []
    for root, _, files in os.walk(directory):
        for file in files:
            relative_path = os.path.join(root, file).replace("\\", "/")  # 替换为正斜杠，适配 YAML
            paths.append(f"{prefix}{relative_path}")
    return paths

def write_to_yaml(asset_paths, yaml_file="pubspec_generated.yaml"):
    with open(yaml_file, "w", encoding="utf-8") as f:
        f.write("flutter:\n")
        f.write("  assets:\n")
        for path in asset_paths:
            f.write(f"    - {path}\n")
    print(f"Asset paths written to {yaml_file}")

# 使用示例
resource_directory = "assets/images"  # 设置你的资源文件夹路径
prefix = ""  # 如果需要在路径前添加前缀，修改此变量
asset_paths = generate_asset_paths(resource_directory, prefix)
write_to_yaml(asset_paths)
