class DDAcount {
  final String? acctno;
  final String? actype;
  final String? ccycd;
  final String? opndate;
  final String? clsdate;
  final String? lastdate;
  final String? plastdate;
  final String? custid;
  final String? status;
  final String? pstatus;
  final String? pors;
  final String? dormdate;
  final String? balance;
  final dynamic curbalance;
  final int? dbegbal;
  final int? crintacr;
  final int? odintacr;
  final int? float1;
  final int? float2;
  final int? float3;
  final int? emkamt;
  final int? mcredit;
  final int? mdebit;
  final int? mavrbal;
  final int? pbno;
  final int? lneno;
  final String? remark;
  final int? trancount;
  final String? crinttied;
  final int? crintmud;
  final String? odinttied;
  final int? odintmud;
  final int? dcrintrate;
  final int? dodintrate;
  final String? drintcd;
  final int? whtax;
  final String? credintcd;
  final int? dmfee;
  final String? dorintcd;
  final DateTime? dmldate;
  final DateTime? intldate;
  final int? cmfacr;
  final int? cvtfloat;
  final int? ipble;
  final String? msrvcd;
  final String? msrvamt;
  final String? msrvsts;
  final int? srvpbl;
  final int? chgecd;
  final int? srvamt;
  final int? odbal;
  final int? odlimit;
  final int? odintamt;
  final int? odsts;
  final String? podsts;
  final String? chgefrq;
  final String? acname;
  final String? chequeno;
  final String? chequests;
  final String? pchequests;
  final int? blockbln;
  final String? lasttime;
  final String? ccycd1;

  DDAcount({
    this.acctno,
    this.actype,
    this.ccycd,
    this.lastdate,
    this.custid,
    this.status,
    this.balance,
    this.curbalance,
    this.dbegbal,
    this.crintacr,
    this.emkamt,
    this.mcredit,
    this.mdebit,
    this.remark,
    this.opndate,
    this.clsdate,
    this.plastdate,
    this.pstatus,
    this.pors,
    this.dormdate,
    this.odintacr,
    this.float1,
    this.float2,
    this.float3,
    this.mavrbal,
    this.pbno,
    this.lneno,
    this.trancount,
    this.crinttied,
    this.crintmud,
    this.odinttied,
    this.odintmud,
    this.dcrintrate,
    this.dodintrate,
    this.drintcd,
    this.whtax,
    this.credintcd,
    this.dmfee,
    this.dorintcd,
    this.dmldate,
    this.intldate,
    this.cmfacr,
    this.cvtfloat,
    this.ipble,
    this.msrvcd,
    this.msrvamt,
    this.msrvsts,
    this.srvpbl,
    this.chgecd,
    this.srvamt,
    this.odbal,
    this.odlimit,
    this.odintamt,
    this.odsts,
    this.podsts,
    this.chgefrq,
    this.acname,
    this.chequeno,
    this.chequests,
    this.pchequests,
    this.blockbln,
    this.lasttime,
    this.ccycd1,
  });

  factory DDAcount.fromJson(Map<String, dynamic> json) {
    return DDAcount(
        status: json['status'],
        mcredit: json['mcredit'],
        balance: json['balance'],
        curbalance: json['curbalance'],
        emkamt: json['emkamt'],
        crintacr: json['crintacr'],
        dbegbal: json['dbegbal'],
        mdebit: json['mdebit'],
        acctno: json['acctno'],
        custid: json['custid'],
        ccycd: json['ccycd'],
        actype: json['actype'],
        lastdate: json['lastdate'],
        opndate: json['opndate'],
        clsdate: json['clsdate'],
        plastdate: json['plastdate'],
        pstatus: json['pstatus'],
        pors: json['pors'],
        dormdate: json['dormdate'],
        odintacr: json['odintacr'],
        float1: json['float1'],
        float2: json['float2'],
        float3: json['float3'],
        mavrbal: json['mavrbal'],
        pbno: json['pbno'],
        lneno: json['lneno'],
        trancount: json['trancount'],
        crinttied: json['crinttied'],
        crintmud: json['crintmud'],
        odinttied: json['odinttied'],
        odintmud: json['odintmud'],
        dcrintrate: json['dcrintrate'],
        dodintrate: json['dodintrate'],
        drintcd: json['drintcd'],
        whtax: json['whtax'],
        credintcd: json['credintcd'],
        dmfee: json['dmfee'],
        dorintcd: json['dorintcd'],
        dmldate: json['dmldate'],
        intldate: json['intldate'],
        cmfacr: json['cmfacr'],
        cvtfloat: json['cvtfloat'],
        ipble: json['ipble'],
        msrvcd: json['msrvcd'],
        msrvamt: json['msrvamt'],
        msrvsts: json['msrvsts'],
        srvpbl: json['srvpbl'],
        chgecd: json['chgecd'],
        srvamt: json['srvamt'],
        odbal: json['odbal'],
        odlimit: json['odlimit'],
        odintamt: json['odintamt'],
        odsts: json['odsts'],
        podsts: json['podsts'],
        chgefrq: json['chgefrq'],
        acname: json['acname'],
        chequeno: json['chequeno'],
        chequests: json['chequests'],
        pchequests: json['pchequests'],
        blockbln: json['blockbln'],
        lasttime: json['lasttime'],
        ccycd1: json['ccycd1']);
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'mcredit': mcredit,
      'balance': balance,
      'mdebit': mdebit,
      'emkamt': emkamt,
      'crintacr': crintacr,
      'dbegbal': dbegbal,
      'ACCTNO': acctno,
      'CUSTID': custid,
      'CCYCD': ccycd,
      'ACTYPE': actype,
      'lastdate': lastdate,
      'remark': remark
    };
  }
}
