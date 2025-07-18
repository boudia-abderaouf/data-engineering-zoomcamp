import requests

base = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow"
years = [2019, 2020, 2021]

for y in years:
    for m in range(1,13):
        fn = f"yellow_tripdata_{y}-{m:02d}.csv.gz"
        url = f"{base}/{fn}"
        print("Downloading", fn)
        r = requests.get(url)
        if r.status_code == 200:
            open(fn, "wb").write(r.content)
        else:
            print("Erreur:", url)
