"""Generate synthetic enterprise LLM API usage logs.

The generated data is synthetic and is intended only for analytics/portfolio use.
It does not represent production OpenAI telemetry or any real organization.
"""

import csv
import random
from datetime import datetime, timedelta
from pathlib import Path

import numpy as np

SEED = 42
N = 5_000_000
CHUNK_SIZE = 100_000
OUTPUT_PATH = Path("ai_usage_logs.csv")

random.seed(SEED)
np.random.seed(SEED)

TEAMS = [
    "Engineering",
    "Customer Support",
    "Sales",
    "HR",
    "Analytics",
]

TASKS = [
    "classification",
    "summarization",
    "question_answering",
    "data_extraction",
    "code_analysis",
]

MODELS = {
    "fast": {
        "input_price": 0.20,
        "output_price": 0.80,
        "quality": 4.00,
        "latency": 600,
    },
    "balanced": {
        "input_price": 0.80,
        "output_price": 3.20,
        "quality": 4.40,
        "latency": 1100,
    },
    "reasoning": {
        "input_price": 2.50,
        "output_price": 10.00,
        "quality": 4.75,
        "latency": 2200,
    },
}

# Synthetic prices in USD per 1M tokens.
# These are illustrative model classes, not current prices of named OpenAI models.
TASK_TOKEN_RANGES = {
    "classification": (100, 400, 10, 60),
    "summarization": (800, 3500, 150, 700),
    "question_answering": (300, 1600, 100, 500),
    "data_extraction": (500, 2500, 50, 250),
    "code_analysis": (1200, 5000, 300, 1200),
}

START_DATE = datetime(2026, 7, 1)

FIELDNAMES = [
    "timestamp",
    "team",
    "task",
    "model",
    "input_tokens",
    "output_tokens",
    "latency_ms",
    "success",
    "quality_score",
    "cost_usd",
]


def generate_row():
    team = random.choice(TEAMS)

    if team == "Engineering":
        task = random.choices(TASKS, weights=[5, 10, 15, 10, 60])[0]
    elif team == "Customer Support":
        task = random.choices(TASKS, weights=[35, 15, 35, 10, 5])[0]
    else:
        task = random.choice(TASKS)

    if team == "Engineering":
        model = random.choices(
            ["fast", "balanced", "reasoning"],
            weights=[10, 40, 50],
        )[0]
    elif team == "HR":
        model = random.choices(
            ["fast", "balanced", "reasoning"],
            weights=[35, 35, 30],
        )[0]
    else:
        model = random.choices(
            ["fast", "balanced", "reasoning"],
            weights=[45, 40, 15],
        )[0]

    in_min, in_max, out_min, out_max = TASK_TOKEN_RANGES[task]

    input_tokens = random.randint(in_min, in_max)
    output_tokens = random.randint(out_min, out_max)

    config = MODELS[model]

    cost = (
        input_tokens / 1_000_000 * config["input_price"]
        + output_tokens / 1_000_000 * config["output_price"]
    )

    latency = (
        config["latency"]
        + input_tokens * 0.12
        + output_tokens * 0.35
        + np.random.normal(0, 150)
    )

    quality = config["quality"] + np.random.normal(0, 0.25)
    quality = round(max(1, min(5, quality)), 2)

    success_probability = {
        "fast": 0.975,
        "balanced": 0.985,
        "reasoning": 0.990,
    }[model]

    success = random.random() < success_probability

    timestamp = START_DATE + timedelta(
        days=random.randint(0, 89),
        seconds=random.randint(0, 86399),
    )

    return {
        "timestamp": timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        "team": team,
        "task": task,
        "model": model,
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
        "latency_ms": round(max(latency, 100)),
        "success": success,
        "quality_score": f"{quality:.2f}",
        # Fixed-point formatting avoids scientific notation in the raw CSV.
        "cost_usd": f"{cost:.6f}",
    }


def main():
    with OUTPUT_PATH.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=FIELDNAMES)
        writer.writeheader()

        written = 0
        while written < N:
            batch_size = min(CHUNK_SIZE, N - written)
            rows = [generate_row() for _ in range(batch_size)]
            writer.writerows(rows)
            written += batch_size
            print(f"Generated {written:,} / {N:,} rows")

    print(f"\nSaved: {OUTPUT_PATH.resolve()}")


if __name__ == "__main__":
    main()
