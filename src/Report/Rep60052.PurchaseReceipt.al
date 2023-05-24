/// <summary>
/// Report TPP Purchase Receipt (ID 60052).
/// </summary>
report 60052 "TPP Purchase Receipt"
{


    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/PurchaseReceipt.rdl';
    Caption = 'Purchase Receipt';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            column(CompName; ComInfo.Name + ComInfo."Name 2")
            {
            }
            column(CompAdd; ComInfo.Address)
            {
            }
            column(CompAdd2; ComInfo."Address 2" + ' ' + ComInfo.City + ' ' + ComInfo."Post Code")
            {
            }
            column(CompPicture; ComInfo.Picture)
            {
            }
            column(CompPhone; 'โทร. ' + ComInfo."Phone No.")
            {
            }
            column(ComFax; 'โทรสาร ' + ComInfo."Fax No.")
            {
            }
            column(ComTaxID; ComInfo."VAT Registration No.")
            {
            }
            column(ComMail; ComInfo."E-Mail")
            {
            }
            column(BuyFromCode; "Buy-from Vendor No.")
            {
            }
            column(BuyFromName; "Buy-from Vendor Name" + "Buy-from Vendor Name 2")
            {
            }
            column(BuyFromAdd; "Buy-from Address")
            {
            }
            column(BuyFromAdd2; "Buy-from Address 2" + ' ' + "Buy-from City" + ' ' + "Buy-from Post Code")
            {
            }
            column(BuyFromContact; "Buy-from Contact")
            {
            }
            column(BuyFromPhone; VendPhone)
            {
            }
            column(BuyFromFax; VendFax)
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentDate; format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DocumentVATText; DocVATTxt)
            {
            }
            column(VendTaxID; "VAT Registration No.")
            {
            }
            column(VendContract; Vendor.Contact)
            {
            }
            column(VendMail; Vendor."E-Mail")
            {
            }
            column(VendorOrderNo; "Vendor Order No.")
            {
            }
            column(PaytoName; "Pay-to Name")
            {
            }
            column(PurchaserName; Purchaser.Name)
            {
            }
            column(PurchaserPhone; Purchaser."Phone No.")
            {
            }
            column(PurhcaserMail; Purchaser."E-Mail")
            {
            }
            column(RefPRNo; RefPRNo)
            {
            }
            column(ColumnCurrency; ColumnCurrency)
            {
            }
            column(PurchaseComment1; PurchaseComment[1])
            {
            }
            column(PurchaseComment2; PurchaseComment[2])
            {
            }
            column(PurchaseComment3; PurchaseComment[3])
            {
            }
            column(OrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Order No.")
            {
            }
            column(PaymentTermDesc; PaymentTerm.Description)
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(AmountTh; AmountTh)
            {
            }
            column(PostingDescription; "Posting Description")
            {
            }
            column(Vendor_Shipment_No_; "Vendor Shipment No.")
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(No; "No.")
                {
                }
                column(LineDescription; Description)
                {
                }
                column(LineDescription2; "Description 2")
                {
                }
                column(LineCost; "Direct Unit Cost")
                {
                }
                column(LineQty; Quantity)
                {
                }
                column(LineUnit; "Unit of Measure Code")
                {
                }
                column(LineNo; LineNo) { }
                column(Output; Output) { }
                column(DataOFLine; DataOFLine) { }

                //tpp.rozn.20200303++
                column(VendorInvNo; VendorInvNo) { }
                column(Location_Code; "Location Code") { }
                column(Posting_Date; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                //tpp.rozn.20200303--

                trigger OnAfterGetRecord()
                begin
                    if (Type <> Type::" ") and (Quantity = 0) then
                        CurrReport.Skip();
                    if Correction then
                        CurrReport.Skip();

                    if "No." <> '' then
                        LineNo += 1;
                    IF DataOFLine >= 17 THEN BEGIN
                        Output := Output + 1;
                        FixLength := 0;
                        DataOFLine := 0;
                    END;
                    DataOFLine += 1;
                end;


            }

            trigger OnAfterGetRecord()
            var

            begin
                Clear(VendPhone);
                Clear(VendFax);
                IF Vendor.GET("Buy-from Vendor No.") THEN BEGIN
                    VendPhone := 'โทร.         ' + Vendor."Phone No.";
                    VendFax := 'โทรสาร ' + Vendor."Fax No.";
                END;
                IF NOT Purchaser.GET("Purchaser Code") THEN
                    Purchaser.INIT;


                IF NOT PaymentTerm.GET("Payment Terms Code") THEN
                    PaymentTerm.INIT;

                LocalFunction."TPP GetPurchaseComment"(6, "No.", PurchaseComment);

                //tpp.rozn.20200303++
                Clear(VendorInvNo);
                PurchaseInvHeader.Reset();
                PurchaseInvHeader.SetRange("No.", "Purch. Rcpt. Header"."No.");
                PurchaseInvHeader.SetRange("No.");
                if PurchaseInvHeader.FindFirst() then
                    VendorInvNo := PurchaseInvHeader."Vendor Invoice No.";
                //tpp.rozn.20200303--

            end;
        }
    }



    trigger OnPreReport()
    begin
        ComInfo.GET;
        ComInfo.CALCFIELDS(Picture);

    end;

    var
        ComInfo: Record "Company Information";
        Vendor: Record Vendor;
        FixLength: Integer;
        NoOfCopies: Integer;

        LineNo: Integer;
        DataOFLine: Integer;
        Output: Integer;

        VendPhone: Text[50];

        VendFax: Text[50];

        DocVATTxt: Text[50];


        ColumnCurrency: Text[50];
        Purchaser: Record "Salesperson/Purchaser";
        RefPRNo: Code[20];

        PurchaseComment: array[100] of Text[250];
        PaymentTerm: Record "Payment Terms";
        LocalFunction: Codeunit "TPP Localized Function";

        AmountTh: Text[200];


        DimName1: Text[50];

        DimName2: Text[50];
        SumQty: Decimal;
        PurhLine: Record "Purch. Rcpt. Line";

        //tpp.rozn.20200303++
        PurchaseInvHeader: Record "Purch. Inv. Header";
        VendorInvNo: Text;
    //tpp.rozn.20200303--
}



