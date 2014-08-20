import sys
import json

def load_sentiments(f):
    
    scores = {}
    for line in f:
        word, score = line.split('\t')
        scores[word] = score.strip()
    #print scores['wow']
    return scores

def load_tweets(f, scores):
    
    #i = 0
    sentiments = []
    for line in f:
        sentiment = 0
        linedict = json.loads(line)
        if linedict.get('lang') == 'en':    #only English tweets
            words = linedict['text'].split()
            for word in words:
                score = scores.get(word)
                    #print score, word
                if score is not None:
                    sentiment += int(score)
                #print sentiment 
        sentiments.append(sentiment)
    return sentiments
            
    

def lines(fp):
    print str(len(fp.readlines()))

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    scores = load_sentiments(sent_file)
    sentiments = load_tweets(tweet_file, scores)
    
    for sentiment in sentiments:
        print sentiment
    

if __name__ == '__main__':
    main()
