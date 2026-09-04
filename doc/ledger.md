# Using Ledger, the money management program
 Install ledger from AUR, pretty long compilation time.
 Install the plugin vim-ledger (preferably using Pathogen. See prev entry)
 
     Entering data in a .ledger file:
	 Enter today's date using <F6> (added a line in .vimrc to use strftime())
	 Auto-completion of the account names: Ass:Ch<C-X><C-O> gives Assets:Checking.
	 zM and zR  to fold and show all folds as usual.
	 There is aligning feature that I am yet to get used to.
	 And automated currency insertion is there too.
     
     Useful things to include:
     	Include directives, so I can keep my business data in its own file, while pulling it into my main one.
	Simple refactorings, like putting "Y 2012" at the top, so I don't have to write the year in each transaction.
	Account aliases, so I can just type "rent", rather than "income:rental" and "repairs:contractor" rather than "expenses:home repair:contractor"

     Reports:
     	Shows balance of all accounts starting with expenses since last October, sorted by total:
		ledger -b "last oct" -S T bal ^expenses
	Shows the register of expenses with multiple entries combined (totalled):
		ledger  register expenses --collapse
	See weekly postings: -W (for register mode)


	
