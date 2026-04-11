-- Table function (UDTF): Parse a delimited string into rows
CREATE OR REPLACE FUNCTION split_tags(tag_string VARCHAR, delimiter VARCHAR)
RETURNS TABLE (tag VARCHAR)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
HANDLER = 'SplitTags'
AS
$$
class SplitTags:
    def process(self, tag_string: str, delimiter: str):
        if tag_string:
            for tag in tag_string.split(delimiter):
                yield (tag.strip(),)
$$;

-- Use in a query
SELECT
order_id,
t.tag
FROM orders, table(split_tags(orders.tags, ',')) AS t;
