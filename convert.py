import json
inputJson = open("assets.json", "r") 
filters = json.loads(inputJson.read())
template = """items{3}["{0}"] = (
	title: "{1}",
	subscription: ListedSubscription(
		url: "{2}",
		title: "{1}",
		homepage: "https://github.com/gorhill/uBlock"
	)
)
blockingItems["{0}"] = items{3}["{0}"]
"""
for key, item in filters.items():
	if item["content"] == "filters":
		contentURL = item["contentURL"]
		if isinstance(contentURL, list):
			contentURL = contentURL[0]
		if "lang" in item:
			print(template.format(key.upper(), item["title"], contentURL,"Lang"))	
		else:
			print(template.format(key.upper(), item["title"], contentURL, ""))

	
