# ARN - arn:aws:lambda:us-east-2:750303481583:function:DoverCodeCommitLambdaFunction_allEvents

import json
import boto3
from datetime import datetime as dt
from string import split

codecommit = boto3.client('codecommit')
sns = boto3.client('sns')

topic_arn = 'arn:aws:sns:us-west-2:384540459344:sandbox-commits-topic"'


def handler(event, context):
    # Log the updated references from the event
    references = event['Records'][0]['codecommit']['references']
    print(f"References: {str(references)}")

    repo = event['Records'][0]['eventSourceARN'].split(':')[5]
    msg = ""
    response = ""
    primary_author = ""

    for record in references:
        commit = record['commit']
        ref = record['ref']
        # get commit info
        try:
            response = codecommit.get_commit(
                commitId=commit, repositoryName=repo)
        except Exception as e:
            print(e)
            print(f"Error getting commit {commit}.")
            raise e

        print(
            f"get_commit response for commit {commit} and repo {repo}:\n\t{str(response)}")

        c = response['commit']
        author = c['author']['name']
        primary_author = author
        authorDate = dt.fromtimestamp(int(split(c['author']['date'])[0]))
        committer = c['committer']['name']
        committerDate = dt.fromtimestamp(int(split(c['committer']['date'])[0]))
        msg += f"Commit {commit}: \n"
        msg += f"Author: {c['author']['name']} <{c['author']['email']}>. Date: {dt.isoformat(authorDate)}\n"

        if primary_author != committer:
            msg += f"\tCommitter: {c['committer']['name']} <{c['committer']['email']}>. Date: {dt.isoformat(committerDate)}\n"

        msg += f"Ref: {ref}\n"
        msg += f"\n{c['message']}\n"

        # get files info
        firstParent = c['parents'][0]
        try:
            response = codecommit.get_differences(
                repositoryName=repo,
                beforeCommitSpecifier=firstParent,
                afterCommitSpecifier=commit)
            print(f"get_differences response = {json.dumps(response)}")
        except Exception as e:
            print(e)
            print("Error doing get_differences")
            raise e

        msg += "Files:\n"
        for diff in response['differences']:
            if 'beforeBlob' in diff:
                msg += f"\t {diff['beforeBlob']['path']}"
            elif 'afterBlob' in diff:
                msg += f"\t {diff['afterBlob']['path']}"
            msg += f" ({diff['changeType']})\n"

            # end of for commit in commits loop

    print(f"publishing message: {msg}\n")

    subj = f"{repo} :: {author}"
    try:
        response = sns.publish(Message=msg,
                               TopicArn=topic_arn = 'arn:aws:,
                               Subject=subj)
    except Exception as e:
        print(e)
        print("Error doing sns.publish")
        raise e

    print(f"publish response: {json.dumps(response)}")
    return response
