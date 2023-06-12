/// <summary>
/// Page FK Get RR Line (ID 60072).
/// </summary>
page 60072 "FK Get RR Line"
{
    SourceTable = "Purchase Line";
    Caption = 'Get PR. Line';
    PageType = List;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    UsageCategory = None;
    SourceTableView = sorting("Document Type", "Document No.", "Line No.");
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater("Group")
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document number.';
                }
                field("Type"; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Quantity"; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Qty. on PO"; Rec."TPP Qty. on PO")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty. on PO field.';
                }
                field("OutStanding PR Quantity"; Rec."TPP OutStanding PR Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the OutStanding PR Quantity field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse.';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction IN [Action::LookupOK, Action::OK] then
            CreateLine();
    end;

    local procedure CreateLine()
    var
        PurchaseLine: Record "Purchase Line";
        PurLine: Record "Purchase Line";
    begin
        PurLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurLine);
        if PurLine.FindSet() then begin
            repeat
                PurchaseLine.init();
                PurchaseLine."Document Type" := POHeader."Document Type";
                PurchaseLine."Document No." := POHeader."No.";
                PurchaseLine."Line No." := PurchaseLine."TPP GetLaseLine"();
                PurchaseLine.Type := PurLine.Type;
                PurchaseLine.Validate("No.", PurLine."No.");
                PurchaseLine.Insert(true);
                PurchaseLine.Description := PurLine.Description;
                PurchaseLine."Description 2" := PurLine."Description 2";
                PurchaseLine.Validate("Location Code", PurLine."Location Code");
                PurchaseLine.Validate("Unit of Measure Code", PurLine."Unit of Measure Code");
                PurchaseLine.Validate(Quantity, PurLine."TPP OutStanding PR Quantity");
                PurchaseLine.Validate("Direct Unit Cost", PurLine."Direct Unit Cost");
                PurchaseLine.Validate("Line Discount %", PurLine."Line Discount %");
                // Ton 2021-10-19 ++
                // PurchaseLine.VALIDATE("Gen. Prod. Posting Group", PurLine."Gen. Prod. Posting Group");
                // PurchaseLine.VALIDATE("VAT Prod. Posting Group", PurLine."VAT Prod. Posting Group");
                if PurLine."Gen. Prod. Posting Group" <> '' then
                    PurchaseLine.VALIDATE("Gen. Prod. Posting Group", PurLine."Gen. Prod. Posting Group");
                if PurLine."VAT Prod. Posting Group" <> '' then
                    PurchaseLine.VALIDATE("VAT Prod. Posting Group", PurLine."VAT Prod. Posting Group");
                // Ton 2021-10-19 --
                PurchaseLine.Validate("Shortcut Dimension 1 Code", PurLine."Shortcut Dimension 1 Code");
                PurchaseLine.Validate("Shortcut Dimension 2 Code", PurLine."Shortcut Dimension 2 Code");
                PurchaseLine."Dimension Set ID" := PurLine."Dimension Set ID";
                PurchaseLine."Planned Receipt Date" := PurLine."Planned Receipt Date";
                PurchaseLine."Requested Receipt Date" := PurLine."Requested Receipt Date";
                PurchaseLine."Expected Receipt Date" := PurLine."Expected Receipt Date";
                PurchaseLine."TPP Reference PR No." := PurLine."Document No.";
                PurchaseLine."TPP Reference PR Line No." := PurLine."Line No.";
                OnAfterCreateLine(PurchaseLine, PurLine); // Ton 2020/10/09
                PurchaseLine.Modify();

                PurLine."TPP OutStanding PR Quantity" := PurLine."TPP OutStanding PR Quantity" - PurchaseLine.Quantity;
                PurLine."TPP OutStanding PR Quantity (Base)" := PurLine."TPP OutStanding PR Quantity (Base)" - PurchaseLine."Quantity (Base)";
                PurLine.Modify();
            until PurLine.next() = 0;
            AftergetOutStanding();
        end;
    end;

    /// <summary>
    /// FKSetPurchHeader.
    /// </summary>
    /// <param name="purchaseHeader">Record "Purchase Header".</param>
    procedure "FK SetPurchHeader"(purchaseHeader: Record "Purchase Header")
    begin
        POHeader.get(purchaseHeader."Document Type", purchaseHeader."No.");
    end;

    local procedure AftergetOutStanding()
    var
        POLine: Query "FK Grouping Get PR";
        PQLine: Record "Purchase Line";
        CheckOutStanding: Boolean;
        PQHeader: Record "Purchase Header";
    begin
        CLEAR(POLine);
        POLine.SetFilter(Document_Type, '%1', POHeader."Document Type");
        POLine.SetFilter(Document_No_, '%1', POHeader."No.");
        POLine.Open();
        while POLine.Read() do begin
            CheckOutStanding := false;
            PQLine.reset();
            PQLine.SetFilter("Document Type", '%1', PQLine."Document Type"::Quote);
            PQLine.SetFilter("Document No.", '%1', POLine.Reference_PR_No_);
            PQLine.SetFilter("TPP OutStanding PR Quantity", '<>%1', 0);
            PQLine.SetFilter("No.", '<>%1', '');
            if PQLine.IsEmpty then
                CheckOutStanding := TRUE
            else
                CheckOutStanding := false;
            if PQHeader.get(0, POLine.Reference_PR_No_) then begin
                PQHeader."TPP completed OutStanding Line" := CheckOutStanding;
                PQHeader.Modify();
            end;
        end;
        CLEAR(POLine);
    end;

    var
        POHeader: Record "Purchase Header";

    // Ton 2020/10/09 Create
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateLine(var PurchaseLine: Record "Purchase Line"; var PurLine: Record "Purchase Line")
    begin
    end;
}