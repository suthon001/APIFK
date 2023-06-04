/// <summary>
/// Page FK Good ReceiptNote List (ID 60055).
/// </summary>
page 60055 "FK Good ReceiptNote List"
{
    ApplicationArea = all;
    Caption = 'Goods Receipt Note List';
    CardPageId = "FK Good ReceiptNote Card";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = sorting("Document Type", "No.") where("Document Type" = filter(Order), Status = filter(Released | "Pending Prepayment"), "Completely Received" = filter(false));
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater("TPP General")
            {
                Caption = 'General';
                field("TPP No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Completely Received"; Rec."Completely Received")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Buy-from Vendor Name 2"; Rec."Buy-from Vendor Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }

                field("TPP Amount"; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }

                field("TPP Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }


            }
        }

        area(FactBoxes)
        {
            part("TPP IncomingDocAttachFactBox"; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = all;
            }
            part("TPP Vendor Details"; "Vendor Details FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
            }
            systempart("TPP Notes"; Notes)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {


        area(processing)
        {


            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        PostDocument(CODEUNIT::"Purch.-Post (Yes/No)", "Navigate After Posting"::"Posted Document");
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    begin
                        ShowPreview();
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Suite;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        PostDocument(CODEUNIT::"Purch.-Post + Print", "Navigate After Posting"::"Do Nothing");
                    end;
                }
                action(PostAndNew)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and New';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'Alt+F9';
                    ToolTip = 'Post the purchase document and create a new, empty one.';

                    trigger OnAction()
                    begin
                        PostDocument(CODEUNIT::"Purch.-Post (Yes/No)", "Navigate After Posting"::"New Document");
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintPurchHeader(Rec);
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = Suite;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    ToolTip = 'Post several documents at once. A report request window opens where you can specify which documents to post.';

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Purchase Orders", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Category6)
                {
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;

                    actionref(Post_Promoted; Post)
                    {
                    }
                    actionref(Preview_Promoted; Preview)
                    {
                    }
                    actionref("Post and &Print_Promoted"; "Post and &Print")
                    {
                    }
                    actionref(PostAndNew_Promoted; PostAndNew)
                    {
                    }
                    actionref("Post &Batch_Promoted"; "Post &Batch")
                    {
                    }
                }
            }
        }
    }
    local procedure PostDocument(PostingCodeunitID: Integer; Navigate: Enum "Navigate After Posting")
    var
        PurchaseHeader: Record "Purchase Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        IsScheduledPosting: Boolean;
        IsHandled: Boolean;
    begin
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

        Rec.SendToPosting(PostingCodeunitID);

        IsScheduledPosting := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not PurchaseHeader.Get(Rec."Document Type", Rec."No.")) or IsScheduledPosting;

        if IsScheduledPosting then
            CurrPage.Close();
        CurrPage.Update(false);

        IsHandled := false;
        OnPostDocumentBeforeNavigateAfterPosting(Rec, PostingCodeunitID, Navigate, DocumentIsPosted, IsHandled);
        if IsHandled then
            exit;

        if PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" then
            exit;

        case Navigate of
            "Navigate After Posting"::"Posted Document":
                begin
                    if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode()) then
                        ShowPostedConfirmationMessage();

                    if IsScheduledPosting or DocumentIsPosted then
                        CurrPage.Close();
                end;
            "Navigate After Posting"::"New Document":
                if DocumentIsPosted then begin
                    Clear(PurchaseHeader);
                    PurchaseHeader.Init();
                    PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
                    OnPostDocumentOnBeforePurchaseHeaderInsert(PurchaseHeader);
                    PurchaseHeader.Insert(true);
                    PAGE.Run(PAGE::"Purchase Order", PurchaseHeader);
                end;
        end;
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderPurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not OrderPurchaseHeader.Get(Rec."Document Type", Rec."No.") then begin
            PurchInvHeader.SetRange("No.", Rec."Last Posting No.");
            if PurchInvHeader.FindFirst() then
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedPurchaseOrderQst, PurchInvHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode())
                then
                    InstructionMgt.ShowPostedDocument(PurchInvHeader, Page::"Purchase Order");
        end;
    end;

    local procedure ShowPreview()
    var
        PurchPostYesNo: Codeunit "Purch.-Post (Yes/No)";
    begin
        PurchPostYesNo.Preview(Rec);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnPostDocumentBeforeNavigateAfterPosting(var PurchaseHeader: Record "Purchase Header"; var PostingCodeunitID: Integer; var Navigate: Enum "Navigate After Posting"; DocumentIsPosted: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostDocumentOnBeforePurchaseHeaderInsert(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    var
        DocumentIsPosted: Boolean;
        ReportPrint: codeunit "Test Report-Print";
        OpenPostedPurchaseOrderQst: Label 'The order is posted as number %1 and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';

}