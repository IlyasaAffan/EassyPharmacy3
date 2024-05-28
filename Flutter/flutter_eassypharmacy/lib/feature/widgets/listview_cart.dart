import 'package:flutter_eassypharmacy/core/core.dart';
import 'package:flutter_eassypharmacy/feature/features.dart';

// import '../screen/home/detail_page.dart';

class ListViewCart extends StatefulWidget {
  const ListViewCart({super.key});

  @override
  State<ListViewCart> createState() => _ListViewCartState();
}

class _ListViewCartState extends State<ListViewCart> {
  String? isLogin;
  int num = 1;
  final List<int> totalPrice = [];

  void sumTotalPrice() {
    setState(() {
      totalPriceGlobal.value = totalPrice.reduce((a, b) => a + b);
    });
  }

  // void _initCartData() {
  //   context.read<GetCartCubit>().getCart(widget.controller!.text);
  // }

  _stateToken() async {
    isLogin = await AccountHelper.getAuthToken();
    setState(() {});
  }

  onClickedCart(BuildContext context) {
    if (isLogin != null) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return const Blank();
      // }));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const LoginOrRegisterPage();
          },
        ),
      );
    }
  }

  stateTotalPrice(int qty, int price) {
    totalPrice.add(qty * price);
    // sumTotalPrice();
    return qty * price;
  }

  @override
  void initState() {
    // _initCartData();
    super.initState();
    _stateToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetCartCubit, GetCartState>(
      builder: (context, state) {
        if (state is LoadingGetCart) {
        } else if (state is NotLoadedGetCart) {
          print("mausk not loaded");
        } else if (state is LoadedGetCart) {
          print("length: ${state.listData.data!.length}");
          //make container for list of medicines
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.listData.data!.length,
            itemBuilder: (context, index) {
              var item = state.listData.data![index];
              var newQty = item.qty!;
              return Container(
                color: systemPrimary50Color,
                margin: const EdgeInsets.fromLTRB(
                  space16,
                  space8,
                  space16,
                  space8,
                ),
                padding: const EdgeInsets.all(space8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(space8)),
                          child: CachedNetworkImage(
                            imageUrl: item.image!,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height / 12,
                            width: MediaQuery.of(context).size.width / 5,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                height: space56,
                                width: space56,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset(Assets.noNetworkImage),
                          ),
                        ),
                        const RowDivider(padding: space16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name!,
                                        style: p16.black.semiBold,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        item.price.toString(),
                                        style: p12.primary.normal,
                                      ),
                                      const ColumnDivider(padding: space16),
                                    ],
                                  ),
                                  Icon(
                                    Assets.removeCart,
                                    color: systemRedColor,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: systemWhiteColor,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              newQty++;
                                            });
                                          },
                                          child: const Icon(Assets.addQty),
                                        ),
                                        Text(
                                          listOrderQty[index].toString(),
                                          style: p18.primary.normal,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (newQty > 1) {
                                                newQty--;
                                              }
                                            });
                                          },
                                          child: const Icon(Assets.subQty),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Total: ${stateTotalPrice(newQty, item.price!)}",
                                    style: p18.primary.normal,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
      listener: (context, state) async {},
    );
  }
}
