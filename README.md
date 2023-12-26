# MemoryCenter-frontend
flashcard-centered application for accelerating and maintaining the consolidation of information

# setup
- copy env.template to .env, .env cannot be empty. If deploying on localhost, can just not include the HOST variable or set it to localhost address. 


- set the proper endpoint in config depending on if production or local 

- firebase login, (if first time, firebase init and below)
    - for firebase init: build/web, Y, N, N to answer hte questions
- flutter build web, and then firebase deploy