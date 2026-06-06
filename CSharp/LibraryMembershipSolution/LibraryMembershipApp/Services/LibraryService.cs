using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibraryMembershipApp.Interfaces;
using LibraryMembershipApp.Models;

namespace LibraryMembershipApp.Services
{
    public  class LibraryService
    {
        private readonly IMemberRepository _memberRepository;
        private readonly IBookRepository _bookRepository;
        private readonly INotificationService _notificationService;

        public LibraryService(IMemberRepository memberRepository, IBookRepository bookRepository, INotificationService notificationService)
        {
            _memberRepository=memberRepository;
            _bookRepository=bookRepository;
            _notificationService=notificationService;
        }

        public string BorrowBook(int memberId, int bookId)
        {
            Member? member = _memberRepository.GetMemberById(memberId);
            Book? book = _bookRepository.GetBookById(bookId);
            


            if (memberId<=0)
            {
                return "Invalid member id";
            }
            else if (bookId <= 0)
            {
                return "Invalid book id";
            }
            else if (member == null)
            {
                return "Member not found";
            }
            else if (member.IsActive == false)
            {
                return "Member is not active";
            }
            else if (book == null)
            {
                return "Book not found";
            }
            else if (book.IsAvailable == false)
            {
                return "Book is not available";
            }

            
            else if(member.BorrowedBookCount >= (member.IsPremiumMember ? 5 : 3))
            {
                return "Borrowing limit reached";
            }
            _bookRepository.MarkBookAsBorrowed(bookId);
            _memberRepository.UpdateBorrowedBookCount(memberId);
            _notificationService.SendBorrowNotification(member.Email, book.BookTitle);

            return "Book borrowed successfully";

        }
    }
}
