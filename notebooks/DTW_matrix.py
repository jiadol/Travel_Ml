import math
from multiprocessing import freeze_support
import pandas as pd
from dtaidistance import dtw
import seaborn as sns
import matplotlib.pyplot as plt
from sqlalchemy import create_engine
from concurrent.futures import ProcessPoolExecutor
from tqdm import tqdm


def compute_dtw_distance(col_dir):
    # Directly access keys and values; col_dir should be a dictionary with two keys
    col1_k, col1_v, col2_k, col2_v = col_dir
    if col1_k != col2_k:
        distance = dtw.distance(col1_v, col2_v)
        if distance > 0:
            distance = math.log10(distance)
        return (col1_k, col2_k, distance)
    else:
        return (col1_k, col2_k, 0)


def main():
    TABLE = "hk_immigration_sum"
    database_url = 'sqlite:///../data/data.sqlite'
    engine = create_engine(database_url)
    query = f"SELECT * FROM {TABLE};"

    df = pd.read_sql_query(query, engine).drop(columns=['日期'])
    print('Data preparation complete')

    columns = df.columns
    distance_matrix = pd.DataFrame(index=columns, columns=columns, data=0.0)

    col_dirs = [(col1, df[col1].values, col2, df[col2].values) for col1 in columns for col2 in columns]

    with ProcessPoolExecutor() as executor:
        results = list(executor.map(compute_dtw_distance, col_dirs))

    for col1, col2, distance in results:
        distance_matrix.loc[col1, col2] = distance

    plt.rc("font", family='MicroSoft YaHei', weight="bold")
    plt.rcParams['axes.unicode_minus'] = False  # 解决保存图像时负号'-'显示为方块的问题
    plt.figure(figsize=(10, 8))
    sns.heatmap(distance_matrix, annot=True, cmap="viridis")
    plt.title("DTW Distance Matrix")
    plt.show()


if __name__ == '__main__':
    freeze_support()  # For Windows support
    main()
