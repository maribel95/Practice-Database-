# Practice-Database-
Practice that consists of creating a database for the management of a streaming video platform.

We want to simulate a streaming platform, which wants to redo its user interface and database. The goal is to create a website that allows, among others, to maintain a community of users registered who can access the audiovisual content they have contracted.

## Data base tables
The data model consists of the following basic tables:

 - A **USERS** table. These users must have, on the handle, a unique user name, password, name and lineage and type of user (there are three types of user: under 9 years old, between 9 and 18 years old, adult). These users may have a contract that allows them to access streaming content. There may be users who do not have a contract.
 - A users **CONTRACTS** table. The date of registration and the type of contract must be known for each contract. There are two types of contract: monthly payment (with a price of €15/month) and quarterly payment (with a price of €40/quarter). These prices may change with some regularity.
 -  A audiovisual **CONTENTS** table that can be consulted. Users with a contract can view and play the list. These streamings are classified in several categories (a piece of content can only belong to one category): series, documentaries, comedy, children's, etc. Likewise, for the purposes of being able to make recommendations, the streams must be linked to the types of users that have been specified previously. These contents must have a title and the YouTube URL of the video.
 - A **FAVORITES** table, which links a user contract with a collection of content or categories of interest.


## To do:

- [X] Allow maintenance (registration and modification) of the user table. So the users you can register and make a contract of the types available. At the moment they are the
monthly and quarterly.
- [X] Allow contract users to add or remove streaming content in your favorites list. Also, it must be possible to specify categories of interest
associated with contracts.
- [X] Allow the administrators of the platform to add new streaming content, making the corresponding links with the user profiles to which they are directed and category.
- [X] Each time a streaming content is added, a recommendation message is generated (in a table of user messages) to each of the users who are interested in the category of the inserted content. These messages must contain the date of the message and the title of the added content.
- [X] Invoices are generated every day for all contracts due on the day in question. These invoices (with the date and amount of the invoice) should be stored in a table in the database.
- [X] Maintenance of the user table.
- [X] Maintenance of the contract table and relationship with users.
- [X] Maintenance of the streaming content table.
- [X] Maintenance of the table of favorite contents.
- [X] Maintenance of the table of favorite categories.
- [X] Allow a user to view streaming content, consulted in the complete list of content or based on their preferences in the form of content favorites or favorite categories.
- [X] Allow a user to consult the recommendations related to the new content added, based on your favorite categories.
- [X] Allow a user to view their invoices.
- [X] Have an automatic system for creating recommendations every time an audiovisual content is added.
- [X] Have an automatic invoice creation system every time I sell a payment term.



