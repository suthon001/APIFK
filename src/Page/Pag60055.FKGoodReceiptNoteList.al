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
        area(Navigation)
        {
            group("TPP O&rder")
            {
                Caption = 'Order';
                action("TPP Dimensions")
                {
                    Image = Dimensions;
                    ApplicationArea = all;
                    Caption = 'Dimensions';
                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action("TPP Statistics")
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Rec.OpenPurchaseOrderStatistics;
                    end;
                }
                action("TPP Approvals")
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //KT ++
                        // WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RECORDID, DATABASE::"Purchase Header", Rec."Document Type", Rec."No.");
                        ApprovalsMgmt.RunWorkflowEntriesPage(Rec.RECORDID, DATABASE::"Purchase Header", Rec."Document Type", Rec."No.");
                        //KT --
                    end;
                }
                action("TPP Co&mments")
                {
                    Caption = 'Comments';
                    ApplicationArea = all;
                    Image = Comment;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No."), "Document Line No." = CONST(0);
                }
            }
            group("TPP Documents")
            {
                Caption = 'Documents';
                action("TPP Receipts")
                {
                    Caption = 'Receipts';
                    Image = Receipt;
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "Order No." = field("No.");
                    RunPageView = sorting("No.");
                }
                action("TPP PostedPurchaseInvoices")
                {
                    Caption = 'Invoice';
                    Image = Invoice;
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageLink = "Order No." = field("No.");
                    RunPageView = sorting("No.");
                }
                action("TPP PostedPurchasePrepmtInvoices")
                {
                    Caption = 'PostedPurchasePrepmtInvoices';
                    Image = PrepaymentInvoice;
                    ApplicationArea = all;
                    RunObject = Page "Posted Purchase Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("TPP Prepayment Credi&t Memos")
                {
                    Caption = 'Prepayment Credi&t Memos';
                    ApplicationArea = all;
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Purchase Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
            }
            group("TPP Warehouse")
            {
                Caption = 'Warehouse';
                action("TPP In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    ApplicationArea = all;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = CONST("Purchase Order"), "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
                action("TPP Whse. Receipt Lines")
                {
                    Caption = 'Whse. Receipt Lines';
                    Image = ReceiptLines;
                    ApplicationArea = all;
                    RunObject = Page "Whse. Receipt Lines";
                    RunPageLink = "Source Type" = CONST(39), "Source Subtype" = CONST(1), "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
            }
        }
        area(Processing)
        {
            group("TPP Report")
            {
                Caption = 'Report';

                action("TPP Send")
                {
                    Caption = 'Send';
                    Image = SendToMultiple;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        PurchaseHeader := Rec;
                        CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                        PurchaseHeader.SendRecords;
                    end;

                }
            }
            group("TPP Relase/Reopen")
            {
                Caption = 'Relase/Reopen';
                action("TPP Release")
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action("TPP Reopen")
                {
                    Caption = 'Reopen';
                    Image = ReOpen;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("TPP F&unctions")
            {
                Caption = 'Functions';
                action("TPP Send IC Purchase Order")
                {
                    Caption = 'Send IC Purchase Order';
                    Image = IntercompanyOrder;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        ICInOutboxMgt: Codeunit ICInboxOutboxMgt;
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                            ICInOutboxMgt.SendPurchDoc(Rec, FALSE);
                    end;
                }
            }

            group("TPP P&osting")
            {
                Caption = 'Posting';
                action("TPP TestReport")
                {
                    Caption = 'Test Report';
                    Image = TestReport;
                    ApplicationArea = all;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        ReportPrint.PrintPurchHeader(Rec);
                    end;
                }
                action("TPP Post")
                {
                    Caption = 'Post';
                    Image = Post;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    var
                        PurchaseBatchPostMgt: Codeunit "Purchase Batch Post Mgt.";
                        PurchaseHeader: Record "Purchase Header";
                        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
                        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
                        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                        // BatchPostParameterTypes: Codeunit "Batch Post Parameter Types"; //KT ++
                        Parameter: Enum "Batch Posting Parameter Type";
                    begin
                        IF ApplicationAreaMgmtFacade.IsFoundationEnabled THEN
                            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

                        CurrPage.SETSELECTIONFILTER(PurchaseHeader);

                        IF PurchaseHeader.COUNT > 1 THEN BEGIN
                            //KT ++
                            // BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice, TRUE);
                            BatchProcessingMgt.SetParameter(Parameter::Invoice, true);
                            // BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Receive, TRUE);
                            BatchProcessingMgt.SetParameter(Parameter::Receive, true);
                            //KT --

                            PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
                            PurchaseBatchPostMgt.RunWithUI(PurchaseHeader, Rec.COUNT, ReadyToPostQst);
                        END ELSE
                            Rec.SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
                    end;
                }
                action("TPP Preview")
                {
                    Caption = 'Preview';
                    ApplicationArea = all;
                    Image = ViewPostedOrder;
                    trigger OnAction()
                    var
                        PurchPostYesNo: Codeunit "Purch.-Post (Yes/No)";
                    begin
                        PurchPostYesNo.Preview(Rec);
                    end;
                }
                action("TPP PostAndPrint")
                {
                    Caption = 'Post And Print';
                    Image = PostPrint;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        Rec.SendToPosting(CODEUNIT::"Purch.-Post + Print");
                    end;
                }
                action("TPP PostBatch")
                {
                    Caption = 'Post Batch';
                    Image = PostBatch;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("TPP RemoveFromJobQueue")
                {
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting;
                    end;
                }
                separator("TPP Separetor")
                {
                    Caption = '';
                }
                group("TPP Prepa&yment")
                {
                    Caption = 'Prepa&yment';
                    action("TPP Prepayment Test &Report")
                    {
                        Caption = 'Prepayment Test &Report';
                        ApplicationArea = all;
                        Ellipsis = true;
                        Image = PrepaymentSimulation;
                        trigger OnAction()
                        begin
                            ReportPrint.PrintPurchHeaderPrepmt(Rec);
                        end;
                    }
                    action("TPP PostPrepaymentInvoice")
                    {
                        Caption = 'Post Prepayment Invoice';
                        ApplicationArea = all;
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec, FALSE);
                        end;
                    }
                    action("TPP Post and Print Prepmt. Invoic&e")
                    {
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        ApplicationArea = all;
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                PurchPostYNPrepmt.PostPrepmtInvoiceYN(Rec, TRUE);
                        end;
                    }
                    action("TPP PostPrepaymentCreditMemo")
                    {
                        Caption = 'Post Prepayment CreditMemo';
                        ApplicationArea = all;
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec, FALSE);
                        end;
                    }
                    action("TPP Post and Print Prepmt. Cr. Mem&o")
                    {
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        ApplicationArea = all;
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            PurchPostYNPrepmt: Codeunit "Purch.-Post Prepmt. (Yes/No)";
                        begin
                            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                PurchPostYNPrepmt.PostPrepmtCrMemoYN(Rec, TRUE);
                        end;
                    }
                }
            }
        }
    }
    var
        ReportPrint: codeunit "Test Report-Print";
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        SkipLinesWithoutVAT: Boolean;
        ReadyToPostQst: Label '%1 out of %2 selected orders are ready for post. \Do you want to continue and post them?';
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;

}