import os
import sys
import json
import xlrd

iexec_out = os.environ['IEXEC_OUT']
iexec_in = os.environ['IEXEC_IN']
dataset_filename = os.environ['IEXEC_DATASET_FILENAME']

try:
    secret_email = os.environ["IEXEC_REQUESTER_SECRET_1"]
except Exception:
    exit(11)

text = 'This email is safe!'

# Check the confidential file exists and open it
try:
    # Open the Workbook
    workbook = xlrd.open_workbook(iexec_in + '/' + dataset_filename)

    # Open the worksheet
    worksheet = workbook.sheet_by_index(0)

    # Iterate the rows and columns
    for i in range(1, worksheet.nrows):
        sheet_email = worksheet.cell_value(i,2)
        # Print the cell values with tab space
        if sheet_email.lower() == secret_email.lower():
            text = "This email is compromised!"
            break


except OSError:
    exit(3)

text += "\n"

# Append some results in /iexec_out/
with open(iexec_out + '/result.txt', 'w+') as fout:
    fout.write(text)

# Declare everything is computed
with open(iexec_out + '/computed.json', 'w+') as f:
    json.dump({ "deterministic-output-path" : iexec_out + '/result.txt' }, f)
