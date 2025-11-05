# A 1-on-1 Learning and Project Collaboration Platform
Our website: https://www.bulletinapp.tech/
## Introduce
A web app where users can offer to teach skills one-on-one, learn from others, and find collaborators for personal or academic projects based on shared skills and interests. 

## Features
* User Authentication & Profiles
> 1. User registration and login (Devise).
> 2. Editable profile 
> 3. Dashboard summarizing: Teaching offers, Projects, and notificatoins.

* Teaching Offers
> 1. Teachers can create a Teaching Offer describing: Skill, title, short description, availability.
> 2. Learners can browse offers and request sessions.
> 3. Lifecycle:
>> i. Pending -> Learner requests session.
>> ii. Approved -> Teacher accepts (Chat opens).
>> iii. Completed -> Both confirm sessions are done.

* Project Collaboration Hub
> 1. Users can post Project Listings describing what they’re building and what kind of people or skills they’re looking for along with the timeline and expected amount of time participants would have to invest.
> 2. Learners can browse projects and request sessions.

* Bulletin
> 1. Users can view Bulletin posts to find an ideal Teaching Offer/Projects, or express their interests.

* Notifications
> 1. Email alerts for: Teaching Offer/Projects requests, approvals, withdraws.


## User Guide
* Sign up and set profile  
> 1. User registers -> fills out a profile and lists skills they can teach.
> 2. Lands on Dashboard showing available actions: Teaching Offer, Projects, Apply, Bulletin and Profile.
* Create or Browse Teaching Offers
> 1. As a Teacher: Click Start a Teaching Offers-> fill form -> Offer created.
> 2. As a Learner: Browse available offers -> click Request Session

* Apply for a Teaching Offer or Project
* Browse or Create Projects
> 1. As a Project Owner: Click Start a Project -> add description and required skills.
> 2. As a Collaborator: Browse projects -> Filter by skill -> click I’m Interested
> 3. Owner receives a notification 


***

Model | Description
-- | --
User | Core entity — can teach, learn, and collaborate.
Skill | Categorizes both teaching offers and projects.
TeachingOffer | A 1-on-1 teaching listing by a user.
Conversation | Private chat between two users (either for session or project).
Project | Project listing with required skills and description.
Bulletin Post | A interest to find a Project/Teaching Offer or find a learning partner
Norification | Norification for application.


***
## Users Stories
### Bulletin Board feature
ID | User Story | SMART Acceptance Criteria
-- | -- | --
BB-1 | As a guest user, I want to view all bulletin posts so that I can explore teaching or collaboration opportunities. | - Posts display with title, description, author, and timestamp.<br>- Accessible via the landing page (/). <br>- Loads within 2 seconds (tested locally).
BB-2 | As a logged-in user, I want to create a new bulletin post so that I can share opportunities or requests. | - Form includes title and description fields.<br>- Optional link to a TeachingOffer or Project.<br>- Post visible immediately after submission.
BB-3 | As a post owner, I want to edit or delete my own bulletin posts so that I can keep my information up to date. | - "Edit" and "Delete" visible only to the post's creator.<br>- Updates reflected instantly on reload.<br>- Deletes trigger confirmation modal.
BB-4 | As a user, I want to search posts by category (Projects, Tutoring, Learning, General, Skill) so that I can quickly find relevant ones. | - Filter dropdown on board.<br>- Filter applied without page error.<br>- "Clear filter" resets view.
BB-5 | As a logged-in user, I want to be able to navigate to the Project/Teaching offer linked to the bulletin post so that I can learn more about it. |  

### Signup/Login

ID | User Story | SMART Acceptance Criteria
-- | -- | --
AU-1 | As a new visitor, I want to sign up with my name, email, and password so that I can access member-only features. | - Form validation (presence, uniqueness of email).<br>- Confirmation message after registration.<br>- Redirect to profile setup after signup.
AU-2 | As a registered user, I want to log in securely so that I can access my dashboard. | - Devise authentication configured.<br>- Invalid credentials show an error message.<br>- Session persists for 30 min of inactivity.
AU-3 | As a user, I want to log out safely so that my session ends and credentials are cleared. | - Logout link visible when logged in.<br>- Redirects to landing page.<br>- No session cookies remain.
AU-4 | As a user, I want to be able to reset my password so that I can log in again if I forget my password. |  

### Profile Page

ID | User Story | SMART Acceptance Criteria
-- | -- | --
PR-1 | As a user, I want to update my profile so that my information is current. | - Editable via /profile/edit.<br>- Validations for max length and image type.<br>- Instant visual update after save.
PR-2 | As a visitor, I want to view other users' profiles so that I can decide whether to collaborate or learn from them. | - Public route /users/:id.<br>- Displays skills, teaching offers, and projects.
PR-3 | As a user, I want to see my teaching offers, projects, and posts on my profile so that I can track my contributions. | - Sectioned view for offers, projects, and posts.<br>- Displays count of each.

### Projects

ID | User Story | SMART Acceptance Criteria
-- | -- | --
PJ-1 | As a user, I want to create a project listing so that I can find collaborators. | - Form requires title and description.-<br> Skill dropdown populated from Skill model.<br>- Confirmation flash after creation.
PJ-2 | As a visitor, I want to browse and sort/filter all projects so that I can explore open opportunities. | - Public /projects index shows cards.<br>- Each card links to full details.
PJ-3 | As a user, I want to express interest in a project so that the owner knows I'd like to collaborate. | - "I'm Interested" button triggers ProjectInterest record.<br>- Notification sent to project owner.
PJ-4 | As a project owner, I want to accept or reject collaborators so that I can manage my team. | - Owner-only access to "Manage Interests."<br>- Status updates reflected immediately.
PJ-5 | As a project owner, I want to edit or delete my own project posts so that I can keep my information up to date. |  

### Learner’s Hub
ID | User Story | SMART Acceptance Criteria
-- | -- | --
LH-1 | As a tutor, I want to create a listing for a skill so that I can teach anyone interested in learning that skill. | - Form requires title and description.<br>- Skill dropdown populated from Skill model.<br>- Confirmation flash after creation.
LH-2 | As a learner, I want to browse and sort/filter all listings so that I can explore available skill listings. | - Public /projects index shows cards.<br>- Each card links to full details.
LH-3 | As a user, I want to express interest in a skill listing so that the teacher knows I'd like to learn from them. | - "I'm Interested" button triggers ProjectInterest record.<br>- Notification sent to project owner.
LH-4 | As a teacher, I want to approve or reject incoming requests so that I control my schedule. | - Owner-only access to "Manage Interests."<br>- Status updates reflected immediately.
LH-5 | As a teacher, I want to edit or delete my own skill listings so that I can keep my information up to date.

### Notifications

ID | User Story | SMART Acceptance Criteria
-- | -- | --
CD-1 | As a developer, I want automated RSpec and Cucumber tests to run on each commit so that I catch regressions early. | - GitHub Actions CI workflow configured.<br>- Test pass required before merge.<br>- CI runs under 3 min.
CD-2 | As a developer, I want to automatically deploy to Heroku after successful tests so that production stays up to date. | - Deployment triggered on main push.<br>- Build succeeds without manual steps.
CD-3 | As a developer, I want Architecture Decision Records and feature docs so that the team understands key design choices. | - ADRs stored under /docs/adr.<br>- README updated after every major increment.
