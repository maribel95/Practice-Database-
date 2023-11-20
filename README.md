# Practice-Database-
Practice that consists of creating a database for the management of a streaming video platform.

We want to simulate a streaming platform, which wants to redo its user interface and database. The goal is to create a website that allows, among others, to maintain a community of users registered who can access the audiovisual content they have contracted.

The data model consists of the following basic tables:

 - A **USERS** table. These users must have, on the handle, a unique user name, password, name and lineage and type of user (there are three types of user: under 9 years old, between 9 and 18 years old, adult). These users may have a contract that allows them to access streaming content. There may be users who do not have a contract.
 - A users **CONTRACTS** table. The date of registration and the type of contract must be known for each contract. There are two types of contract: monthly payment (with a price of €15/month) and quarterly payment (with a price of €40/quarter). These prices may change with some regularity.
 -  A audiovisual **CONTENTS** table that can be consulted. Users with a contract can view and play the list. These streamings are classified in several categories (a piece of content can only belong to one category): series, documentaries, comedy, children's, etc. Likewise, for the purposes of being able to make recommendations, the streams must be linked to the types of users that have been specified previously. These contents must have a title and the YouTube URL of the video.
 - A **FAVORITES** table, which links a user contract with a collection of content or categories of interest.
