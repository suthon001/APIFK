/// <summary>
/// Page FK Good ReceiptNote Card (ID 60056).
/// </summary>
page 60056 "FK Good ReceiptNote Card"
{
    Caption = 'Goods Receipt Note Card';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = sorting("Document Type", "No.") where("Document Type" = filter(Order), Status = filter(Released | "Pending Prepayment"));
    layout
    {
        area(Content)
        {
            group("TPP General")
            {
                Caption = 'General';
                field("TPP No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("TPP Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = all;
                }
                group("TPP Buy-from")
                {
                    Caption = 'Buy-From';
                    field("TPP Buy-from Address"; Rec."Buy-from Address")
                    {
                        ApplicationArea = all;
                    }
                    field("TPP Buy-from Address 2"; Rec."Buy-from Address 2")
                    {
                        ApplicationArea = all;
                    }
                    field("TPP Buy-from City"; Rec."Buy-from City")
                    {
                        ApplicationArea = all;
                    }
                    field("TPP Buy-from County"; Rec."Buy-from County")
                    {
                        ApplicationArea = all;
                    }

                    field("TPP Buy-from Post Code"; Rec."Buy-from Post Code")
                    {
                        ApplicationArea = all;
                    }
                    field("TPP Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                    {
                        ApplicationArea = all;
                    }
                    field("TPP Buy-from Contact No."; Rec."Buy-from Contact No.")
                    {
                        ApplicationArea = all;
                    }
                }
                field("TPP Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = all;
                }
                field("TPP Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = all;
                }
                field("TPP No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = all;
                }
                field("TPP Order Date"; Rec."Order Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Vendor Order No."; Rec."Vendor Order No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                }
                field("TPP Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = all;
                }
                field("TPP Status"; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("TPP Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = all;
                }
            }
            part("TPP PurchLines"; "FK Good ReceiptNote Subpage")
            {
                Caption = 'Lines';
                ApplicationArea = all;
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                SubPageView = sorting("Document Type", "Document No.", "Line No.");
            }
            group("TPP Invoice Details")
            {
                Caption = 'Invoice Details';
                field("TPP Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = all;
                }
                field("TPP VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("TPP Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = all;
                }
                field("TPP Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = all;
                }
                field("TPP Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = all;
                }
                field("TPP Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = all;
                }
                field("TPP On Hold"; Rec."On Hold")
                {
                    ApplicationArea = all;
                }
                field("TPP Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                    ApplicationArea = all;
                }
                field("TPP Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = all;
                }
                field("TPP Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = all;
                }
            }
            group("TPP Shipping and Payment")
            {
                Caption = 'Shipping and Payment';

                field("TPP Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }


                field("TPP Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                }

                field("TPP Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("TPP Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = all;
                }
                field("TPP Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = all;
                }
                field("TPP Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = all;
                }

                field("TPP Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = all;
                }

                field("TPP Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = all;
                }
            }

            group("TPP Pay-to")
            {
                Caption = 'Pay-to';
                field("TPP Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = all;
                }
                field("TPP Pay-to Address"; Rec."Pay-to Address")
                {
                    ApplicationArea = all;
                }
                field("TPP Pay-to Address 2"; Rec."Pay-to Address 2")
                {
                    ApplicationArea = all;
                }
                field("TPP Pay-to City"; Rec."Pay-to City")
                {
                    ApplicationArea = all;
                }

                field("TPP Pay-to County"; Rec."Pay-to County")
                {
                    ApplicationArea = all;
                }

                field("TPP Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Pay-to Contact No."; Rec."Pay-to Contact No.")
                {
                    ApplicationArea = all;
                }
                field("TPP Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = all;
                }
            }
            group("TPP Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("TPP Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = all;
                }
                field("TPP Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = all;
                }
                field("TPP Entry Point"; Rec."Entry Point")
                {
                    ApplicationArea = all;
                }
                field("TPP Area"; Rec.Area)
                {
                    ApplicationArea = all;
                }
            }
            group("TPP Prepayment")
            {
                Caption = 'Prepaymemt';
                field("TPP Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = all;
                }
                field("TPP Compress Prepayment"; Rec."Compress Prepayment")
                {
                    ApplicationArea = all;
                }
                field("TPP Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field("TPP Prepayment Due Date"; Rec."Prepayment Due Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %")
                {
                    ApplicationArea = all;
                }
                field("TPP Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date")
                {
                    ApplicationArea = all;
                }
                field("TPP Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(FactBoxes)
        {
            part("TPP Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = all;
                SubPageLink = "Table ID" = CONST(38), "No." = FIELD("No."), "Document Type" = FIELD("Document Type");
            }
            part("TPP PendingApproval"; "Pending Approval FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "Table ID" = CONST(38), "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");
            }
            part("TPP Vendor Statistics"; "Vendor Statistics FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
            }


            part("TPP PurchaseLine Factbox"; "Purchase Line FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }

            systempart("TPP Notes"; Notes)
            {
                ApplicationArea = all;
            }
        }

    }
    var
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        SkipLinesWithoutVAT: Boolean;
        ReadyToPostQst: Label '%1 out of %2 selected orders are ready for post. \Do you want to continue and post them?';
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
}
