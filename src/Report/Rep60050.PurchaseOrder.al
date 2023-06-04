/// <summary>
/// Report TPP Purchase Order (ID 60050).
/// </summary>
report 60050 "TPP Purchase Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/PurchaseOrder.rdl';
    Caption = 'Purcahse Order';
    PreviewMode = PrintLayout;
    UsageCategory = None;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.";
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
            column(CompPhone; ComInfo."Phone No.")
            {
            }
            column(ComFax; ComInfo."Fax No.")
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
            column(BuyFromName; "Buy-from Vendor Name" + "Purchase Header"."Buy-from Vendor Name 2")
            {
            }
            column(BuyFromAdd; "Buy-from Address")
            {
            }
            column(BuyFromAdd2; "Buy-from Address 2" + ' ' + "Purchase Header"."Buy-from City" + ' ' + "Purchase Header"."Buy-from Post Code")
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
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentAmount; Amount)
            {
            }
            column(DocumentVATAmount; "Amount Including VAT")
            {
            }
            column(DocumentVAT; "Amount Including VAT" - Amount)
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
            column(ExpectedReceiptDate; "Expected Receipt Date")
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
            column(TotalAmt1; TotalAmt[1])
            {
            }
            column(TotalAmt2; TotalAmt[2])
            {
            }
            column(TotalAmt3; TotalAmt[3])
            {
            }
            column(TotalAmt4; TotalAmt[4])
            {
            }
            column(TotalAmt5; TotalAmt[5])
            {
            }
            column(VatText; VatText)
            {
            }
            column(CommentLine; CommentLine[1])
            {

            }
            column(CommentLine2; CommentLine[2])
            {

            }
            column(CommentLine3; CommentLine[3])
            {

            }
            column(deliveryAddress; deliveryAddress)
            {

            }
            column(Comment; Comment) { }
            column(DimName2; DimName2)
            {

            }
            column(DimName1; DimName1)
            {

            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
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
                column(LineDiscounAmount; "Line Discount Amount")
                {
                }
                column(LineNo; LineNo)
                {
                }
                column(Output; Output) { }
                column(DataOFLine; DataOFLine) { }
                column(Line_Amount; "Line Amount") { }

                trigger OnAfterGetRecord()
                begin

                    if "No." <> '' then
                        LineNo += 1;
                    DataOFLine += 1;
                    IF DataOFLine >= 16 THEN BEGIN
                        Output := Output + 1;

                        DataOFLine := 1;
                    END;


                end;
            }
            trigger OnAfterGetRecord()
            var
                PurchLine: Record "Purchase Line";
                ltAmtLbl: Label '%1 (%2)', Locked = true;
            begin
                LocalFunction."TPP PurchStatistic"("Document Type".AsInteger(), "No.", TotalAmt, VatText);
                LocalFunction."TPP GetPurchaseComment"("Document Type".AsInteger(), "No.", CommentLine);
                IF Vendor.GET("Buy-from Vendor No.") THEN BEGIN
                    VendPhone := 'TEL.         ' + Vendor."Phone No.";
                    VendFax := 'FAX. ' + Vendor."Fax No.";
                END;
                if not Purchaser.get("Purchaser Code") then
                    Purchaser.init();
                IF NOT PaymentTerm.GET("Payment Terms Code") THEN
                    PaymentTerm.INIT();


                IF Currency.Get("Currency Code") then;
                IF "Currency Code" <> '' THEN
                    AmountTh := STRSUBSTNO(ltAmtLbl, LocalFunction."TPP NumberEngText"(TotalAmt[5], "Currency Code"), Currency."ISO Code")
                ELSE
                    AmountTh := LocalFunction."TPP FormatNoThaiText"(TotalAmt[5]);

                PurchLine.RESET();
                PurchLine.SETRANGE("Document Type", "Document Type");
                PurchLine.SETRANGE("Document No.", "No.");
                PurchLine.SETFILTER("TPP Reference PR No.", '<>%1', '');
                IF PurchLine.FindFirst() THEN
                    RefPRNo := PurchLine."TPP Reference PR No.";


                GLSetup.GET();
                IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code") THEN
                    DimName1 := DimValue.Name;
                IF DimValue.GET(GLSetup."Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code") THEN
                    DimName2 := DimValue.Name;


                deliveryAddress := "Ship-to Address" + ' ' + "Ship-to Address 2" + ' ' + "Ship-to City" + ' ' + "Ship-to Post Code";
            end;
        }
    }

    trigger OnPreReport()
    begin
        ComInfo.GET();
        ComInfo.CALCFIELDS(Picture);
    end;

    var
        ComInfo: Record "Company Information";
        deliveryAddress: Text[250];

        LineNo: Integer;
        DataOFLine: Integer;
        Output: Integer;
        Vendor: Record Vendor;

        VendPhone: Text[50];

        VendFax: Text[50];

        DocVATTxt: Text[50];

        TotalAmt: array[100] of Decimal;
        VatText: Text[30];
        CommentLine: array[100] of text[250];

        Purchaser: Record "Salesperson/Purchaser";
        RefPRNo: Code[30];


        PaymentTerm: Record "Payment Terms";
        LocalFunction: Codeunit "TPP Localized Function";

        AmountTh: Text;

        DimName1: Text[50];

        DimName2: Text[50];

        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";


        Currency: Record Currency;
}

