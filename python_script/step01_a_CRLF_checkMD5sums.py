import os
import subprocess
from datetime import datetime

# Define variables
WORKDIR = "<insert raw sequence directory path>"

# Function to execute shell commands and handle errors
def run_command(command):
    try:
        subprocess.check_call(command, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] FAIL")
        exit(1)

# Main script
def main():
    os.chdir(WORKDIR)
    job_id = os.getenv('JOB_ID', 'Unknown')

    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Starting to cat multilane data")

    # Process T4B005
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Forward read T4B005")
    run_command("cat T4B005_ZKDN230030242-1A_HVVV3DSX7_L4_1.fq.gz T4B005_ZKDN230030242-1A_HVTJTDSX7_L4_1.fq.gz > T4B005_cat_R1.fq.gz")
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Done with forward read T4B005")

    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Reverse read T4B005")
    run_command("cat T4B005_ZKDN230030242-1A_HVVV3DSX7_L4_2.fq.gz T4B005_ZKDN230030242-1A_HVTJTDSX7_L4_2.fq.gz > T4B005_cat_R2.fq.gz")
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Done with reverse read T4B005")

    # Process T2B087
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Forward read T2B087")
    run_command("cat T2B087_ZKDN230030221-1A_HVVV3DSX7_L2_1.fq.gz T2B087_ZKDN230030221-1A_HVTJTDSX7_L4_1.fq.gz > T2B087_cat_R1.fq.gz")
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Done with forward read T2B087")

    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Reverse read T2B087")
    run_command("cat T2B087_ZKDN230030221-1A_HVVV3DSX7_L2_2.fq.gz T2B087_ZKDN230030221-1A_HVTJTDSX7_L4_2.fq.gz > T2B087_cat_R2.fq.gz")
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Done with reverse read T2B087")

    # Process T3B092
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; T3B092")
    individuals = ["T3B092"]
    for ind in individuals:
        run_command(f"cat {ind}*_R1* > {ind}_S17_L001_R1_001.fq.gz")
        run_command(f"cat {ind}*_R2* > {ind}_S17_L001_R2_001.fq.gz")
    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Done with T3B092")

    print(f"[{datetime.now().strftime('%Y-%m-%d %T')}] JOB ID {job_id}; Done concatenating multilane data")

if __name__ == "__main__":
    main()
