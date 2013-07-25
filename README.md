# Rails 3 and Thinking Sphinx 3

I'm using thinking-sphinx to index my ```document``` model.

I'm finding that ```rake ts:index``` is extremely slow and not finishing when there are more than 4 indexed associations.

To simulate, run through the steps below and then edit ```app/indices/document_index.rb``` to uncomment some more of the index definitions. Then run ```rake ts:index``` and it will never finish!

Note on the data: this is a slightly contrived example, but my real app has a similar data model where one particular model is often associated with all 243 countries (for example). I suspect this is creating very large join tables when sphinx is generating indexes so I'm wondering how to optmise this.

## Setup

0. You may need to install latest version of sphinx (2.0.X)... use "apt-get install sphinxsearch" (on ubuntu)
     Or run "searchd --version" to make sure you're using latest version (2.0.X). I'm using Sphinx 2.0.4-release (r3135)

1. git clone this project

2. edit ```config/database.yml``` to suit your db username/password preferences (I'm using mysql)

3. Run ```bundle install``` and then ```rake db:create db:migrate ts:rebuild```

4. Seed the database with dummy data: ```rake db:seed```

   Note: This will create lots of tags, subscribers and other associations and then generate 300 documents, each with 50 of each association associated! (Crazy I know, but does reflect similar data in my real app.)

5. The following reproduces the issue I'm having with indexing:

  I've commented out some of the indexes definitions in ```app/indices/document_index.rb``` so that it won't take forever to generate the index. If you uncomment a few of these and run ```rake ts:rebuild```, it will not finish indexing (beware this step can create very large tmp tables on your machine and you may run out of disk space before the process finishes. I was getting upwards of 22Gig files and then ran out of space!)

## Indexing stats

In ```app/indices/document_index.rb```:

Using ```time rake ts:rebuild```, reports

* 4   seconds - when 1 association  (images) is indexed
* 6   seconds - when 2 associations (images and subscribers) are indexed
* 23  seconds - when 2 associations (images and countries) are indexed
* 115 seconds - when 3 associations (images, subscribers and tags) are indexed
* 113 seconds - when 3 associations (images, subscribers and videos) are indexed (just to prove it's not specific problem to tags)
* ꝏ          - when 4 associations or more are selected.

## What sphinx is doing

Mysql takes forever to run the following thinking-sphinx query. This is found in ```config/development.sphinx.conf```

I guess the real question I'm asking is, how to write ```app/indices/document_index.rb``` to optimise the query below so that it finishes.

```sql
SELECT SQL_NO_CACHE
    documents.id * 2 + 0 AS id,
    'Document' AS sphinx_internal_class_name,
    GROUP_CONCAT(images.title
        SEPARATOR ' ') AS images,
    GROUP_CONCAT(subscribers.title
        SEPARATOR ' ') AS subscribers,
    GROUP_CONCAT(tags.name
        SEPARATOR ' ') AS tags,
    GROUP_CONCAT(videos.title
        SEPARATOR ' ') AS videos,
    documents.id AS sphinx_internal_id,
    'Document' AS sphinx_internal_class,
    0 AS sphinx_deleted,
    GROUP_CONCAT(images.id
        SEPARATOR ',') AS image_ids,
    GROUP_CONCAT(subscribers.id
        SEPARATOR ',') AS subscriber_ids,
    GROUP_CONCAT(tags.id
        SEPARATOR ',') AS tag_ids,
    GROUP_CONCAT(videos.id
        SEPARATOR ',') AS video_ids,
    UNIX_TIMESTAMP(documents.updated_at) AS updated_at
FROM
    documents
        LEFT OUTER JOIN
    documents_images ON documents_images.document_id = documents.id
        LEFT OUTER JOIN
    images ON images.id = documents_images.image_id
        LEFT OUTER JOIN
    documents_subscribers ON documents_subscribers.document_id = documents.id
        LEFT OUTER JOIN
    subscribers ON subscribers.id = documents_subscribers.subscriber_id
        LEFT OUTER JOIN
    documents_tags ON documents_tags.document_id = documents.id
        LEFT OUTER JOIN
    tags ON tags.id = documents_tags.tag_id
        LEFT OUTER JOIN
    documents_videos ON documents_videos.document_id = documents.id
        LEFT OUTER JOIN
    videos ON videos.id = documents_videos.video_id
WHERE
    (documents.delta = 0 AND documents.id BETWEEN $start AND $end)
GROUP BY documents.id , documents.id , documents.updated_at
ORDER BY NULL
```

And here's the explain for that (note it confirms table indexes are being used)

```
id  select_type table                 type    possible_keys   key     key_len ref                                         rows  Extra
1   SIMPLE      documents             range   PRIMARY         PRIMARY 4       NULL                                        300   Using where; Using filesort
1   SIMPLE      documents_images      ref     index_documents_images_on_document_id_and_image_id  index_documents_images_on_document_id_and_image_id  5 rails3-ts-example.documents.id  25  Using index
1   SIMPLE      images                eq_ref  PRIMARY         PRIMARY 4       rails3-ts-example.documents_images.image_id 1
1   SIMPLE      documents_subscribers ref     index_documents_subscribers_on_document_id_and_subscriber_id  index_documents_subscribers_on_document_id_and_subscriber_id  5 rails3-ts-example.documents.id  25  Using index
1   SIMPLE      subscribers           eq_ref  PRIMARY         PRIMARY 4       rails3-ts-example.documents_subscribers.subscriber_id   1
1   SIMPLE      documents_tags        ref     index_documents_tags_on_document_id_and_tag_id  index_documents_tags_on_document_id_and_tag_id  5 rails3-ts-example.documents.id  32  Using index
1   SIMPLE      tags                  eq_ref  PRIMARY         PRIMARY 4       rails3-ts-example.documents_tags.tag_id     1
1   SIMPLE      documents_videos      ref     index_documents_videos_on_document_id_and_video_id  index_documents_videos_on_document_id_and_video_id  5 rails3-ts-example.documents.id  25  Using index
1   SIMPLE      videos                eq_ref  PRIMARY         PRIMARY 4       rails3-ts-example.documents_videos.video_id 1
```
