# MemoryCenter-frontend
flashcard-centered application for accelerating and maintaining the consolidation of information in the human brain

## Specifics
The frontend is targetted at web and ios (because my clients all have iphones). Currently just testflight for friends and family, as the backend is not necessarily fully optimized for scalability and security. 

The idea is to use the web interface to input data. There are multiple input methods, and we expand them as users come up with ways they think would decrease the time from [idea in their head of what they want to study] -> [properly saved into the backend database]. There are currently 3 methods
1. the naive approach, just enter in the front and back, and buttons for deletion. 
2. for languages, a quick way i found was to use google translate. Seperate the words or phrases you want to learn with a delimiter, like a period, and then copy paste. You can get many words quickly like this. The period is the best delimiter for google translate, but sometimes periods come up in names or words, so sometimes you might prefer the , or semicolon. 
3. i've found that you can go even faster with chatgpt, and get more reliable and complete translations. Additionally, you can solve formatting problems like in arabic where ordering is reversed. However, it is easier for the model if you can localize the word with translation, rather than all the words and all translations like in the above. Therefore, we implement a line seperated method to allow this. This method can allow you to input 100 translations of a topic you know nothing about, with transliteration, brief context, and the lettering, in just seconds. 

We know maneuvering on the computer and typing is faster than the corresponding things on the phone. That is why we recommend the computer for the input. But on the contrary, we recommend the phone for the studying. You can study on the computer, but there are many reasons to target an app for the learning phase. 

Firstly, we have access to our phones, and a place to use it, almost 24/7, as opposed to the computer. Secondly, with a computer you are constrained to sitting down, in the same spot, which we know is contrary to brain activity. Not just your mental functioning from walking around and moving, but also for imprinting memories. It is helpful to have different contexts for learning, so you have more hooks and more reason for your brain to save the item in memory. Thirdly, this is meant to combat scrolling. In the bathroom, or when stranded between engagements, for those who do not wish to meditate, social media is often the first thing reached for. I hope this can be a productive alternate use of these dead times, and I have hoped to gamify the app and learning process to help with this. Fourth, the right swipe and left swipe actions are more natural on the phone, and mimic some ui that we are used to. 

# setup
- copy env.template to .env, .env cannot be empty. If deploying on localhost, can just not include the HOST variable or set it to localhost address. 

- in config.dart, set debug false or true based on production or debug

- Set other variables in config.dart as you wish

- for deployment to ios
    - prepare to deal with annoying xcode and bad apple design. 
    - usually better to build through flutter 'flutter build ios', after opening the simulator on your own. 
    - use xcode for things like single icon and actually archiving and distributing. And initial setting of provisioning profile. 
    - version control and that even seems to be better just done on your own


- for deployment to firebase
    - firebase login, (if first time, firebase init and below)
    - for firebase init: build/web, Y, N, N to answer hte questions
- flutter build web, and then firebase deploy
- also need to include the google plist file (and manually in xcode)